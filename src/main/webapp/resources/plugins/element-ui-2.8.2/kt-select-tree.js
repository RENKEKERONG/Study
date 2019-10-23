/**
 * 树形下拉选 v2.0
 *
 * -- 修改：
 * @note 取消【一维数组自动转多维数组的方法】
 * @note 不再区分 【静态数据和动态数据的绑定方式】
 *
 * -- 新增
 * @note 提供multiple:true && filterable:true 下的可搜索多选
 * @note 提供slot树节点内容自定义
 * @note 简化代码
 *
 */

let html =
    '<el-popover  ' +
            'ref="popover"'+
            'popper-class="kt-select-tree__popover"'+
            'placement="bottom-start"'+
            'trigger="click">'+
        '<div>'+
            '<el-input class="kt-select-tree__input" v-if="filterable" placeholder="请输入关键字" v-model="searchValue" size="mini"></el-input>'+
            '<el-tree '+
                    'ref="tree"'+
                    'class="kt-select-tree"'+
                    ':style="{\'min-width\':treeWidth}"'+
                    ':data="treeData"'+
                    ':props="dynaDefProps"'+
                    ':node-key="dynaDefProps.id"'+
                    '@node-click="onNodeClick"'+
                    ':highlight-current="!multiple"'+
                    ':expand-on-click-node="false"'+
                    ':default-expanded-keys="defaultExpandedKeys"'+
                    ':show-checkbox="multiple"'+
                    ':default-expand-all="defaultExpandAll"'+
                    ':filter-node-method="onTreeFilter"'+
                    '@check="onCheck">'+
                 '<span class="kt-select-tree_label" slot-scope="{ node, data }">'+
                    '<slot :node="node" :data="data">{{ node.label }}</slot>'+
                 '</span>'+
            '</el-tree>'+
        '</div>'+
        <!-- 触发html -->
        '<el-select '+
                   'ref="select"'+
                   'slot="reference"'+
                   'popper-class="kt-select-tree__option"'+
                   'v-model="labelValue"'+
                   ':style="{\'width\':width}"'+
                   ':size="size"'+
                   ':multiple="multiple"'+
                   ':clearable="clearable"'+
                   ':collapse-tags="collapseTags"'+
                   ':placeholder="placeholder"'+
                   '@change="onChange"'+
                   '@clear="onClear">'+
        '</el-select>'+
    '</el-popover>';

Vue.component('kt-select-tree', {
    template: html,
    // 设置绑定参数
    model: {
        prop: 'value',
        event: 'input'
    },
    data() {
        return {
            // 传参的值
            modelValue: void 0,
            // 展示框的值
            labelValue: void 0,
            // 搜索框的值
            searchValue: void 0,
            // 树节点宽度
            treeWidth: 'auto',
            // 扁平化数据
            options: [],
        }
    },
    props: {
        data: Array,
        value: String | Array,
        defaultProps: Object,
        // 对外暴露的属性
        width: String,
        size: {
            type: String,
            default: 'mini'
        },
        placeholder: {
            type: String,
            default: '请选择'
        },
        multiple: {
            type: Boolean,
            default: false
        },
        filterable: {
            type: Boolean,
            default: false
        },
        clearable: {
            type: Boolean,
            default: false
        },
        defaultExpandedKeys: Array,
        defaultExpandAll: {
            type: Boolean,
            default: false
        },
        collapseTags: {
            type: Boolean,
            default: true
        }
    },
    // --------------------------------------------------- 计算属性 --------------------------------------------------
    computed: {
        // 树节点配置选项
        dynaDefProps() {
            return Object.assign({}, {
                parentId: 'parentId',
                id: 'id',
                label: 'name',
                children: 'children',
                filter: 'filter'
            }, this.defaultProps)
        },
        // 树节点数据
        treeData() {
            if (this.data.length > 0) {
                // 备份降维模型
                this.options = this.flattenTree(this.data);
                // ⭐⭐⭐ 初始化绑定节点 ⭐⭐⭐
                this.$nextTick(() => {
                    if (this.multiple) {
                    if (Array.isArray(this.value) && this.value.length > 0) {
                        this.labelValue = this.options.filter(node => this.value.includes(node[this.dynaDefProps.id])).map(node => node[this.dynaDefProps.label]);
                        this.$refs.tree.setCheckedKeys(this.value);
                        this.modelValue = this.value;
                    }
                } else {
                    if (this.value) {
                        this.labelValue = this.options.filter(node => node[this.dynaDefProps.id] === this.value).map(node => node[this.dynaDefProps.label])[0];
                        this.$refs.tree.setCurrentKey(this.value);
                        this.modelValue = this.value;
                    }
                }
            });
                // 初始化树模型
                return this.data;
            }
        }
    },
    // --------------------------------------------------- 监听属性 --------------------------------------------------
    watch: {
        searchValue(val) {
            this.debounceQuery(val);
        },
        modelValue(val) {
            // ⭐⭐⭐ modelValue -> labelValue
            if (val && Array.isArray(this.options) && this.options.length > 0) {
                if (this.multiple) this.labelValue = this.options.filter(node => val.includes(node[this.dynaDefProps.id])).map(node => node[this.dynaDefProps.label]);
            else this.labelValue = this.options.filter(node => node[this.dynaDefProps.id] === val)[0][this.dynaDefProps.label];
            }
            // ⭐⭐⭐ modelValue -> value
            this.$emit('input', val);
        },
        // ⭐⭐⭐ value -> labelValue
        value(val) {
            if (!val) this.labelValue = void 0;
            if (val && Array.isArray(this.options) && this.options.length > 0) {
                if (this.multiple) this.labelValue = this.options.filter(node => val.includes(node[this.dynaDefProps.id])).map(node => node[this.dynaDefProps.label]);
            else this.labelValue = this.options.filter(node => node[this.dynaDefProps.id] === val)[0][this.dynaDefProps.label];
            }
            // ⭐⭐⭐ modelValue -> value
            this.$emit('input', val);
        }
    },
    // --------------------------------------------------- 一般方法 --------------------------------------------------
    methods: {
        /* 点击节点 */
        onNodeClick(node, data) {
            if (!this.multiple) {
                // 绑定值
                this.modelValue = node[this.dynaDefProps.id];
                // 对外暴露绑定函数
                this.$emit('node-click', node, data);
                // 隐藏菜单
                this.onCloseTree();
            }
        },
        /* 点击节点复选框 */
        onCheck(node, data) {
            if (this.multiple) {
                let juniorNodes = data.checkedNodes.filter(node => !node[this.dynaDefProps.children]);
                // 绑定值
                this.modelValue = juniorNodes.map(node => node[this.dynaDefProps.id]);
                // 对外暴露绑定函数
                this.$emit('check', node, data);
            }
        },
        /* 节点过滤函数 */
        onTreeFilter(value, data) {
            if (!value) return true;
            return data[this.dynaDefProps.filter] ? data[this.dynaDefProps.label].indexOf(value) !== -1 || data[this.dynaDefProps.filter].indexOf(value.toUpperCase()) !== -1 : data[this.dynaDefProps.label].indexOf(value) !== -1;
        },
        /* 延迟过滤节点 */
        debounceQuery: _.debounce(function (val) {
            this.$refs.tree.filter(val);
        }, 800),
        /* popover菜单关闭 */
        onCloseTree() {
            this.$refs.popover.showPopper = false;
        },
        /* 下拉选value变化 */
        onChange(val) {
            if (this.multiple) {
                this.labelValue = val;
                this.modelValue = this.options.filter(node => val.includes(node[this.dynaDefProps.label])).map(node => node[this.dynaDefProps.id]);
                this.$nextTick(() => {
                    this.$refs.tree.setCheckedKeys(this.modelValue);
            })
            }
        },
        /* 单选模式下清空 */
        onClear() {
            this.modelValue = void 0;
        },
        /* 数组降维 */
        flattenTree(arr = []) {
            let result = [], copy = $.extend(true, [], arr); // 深度拷贝数组
            const fun = (arr) => {
                arr.forEach(node => {
                    result.push(node);
                if (this.isArray(node)) fun(node[this.dynaDefProps.children]);
                delete node[this.dynaDefProps.children];
            });
            };
            fun(copy);
            return result;
        },
        /* 判断数组 */
        isArray(data) {
            return data[this.dynaDefProps.children] && Array.isArray(data[this.dynaDefProps.children]) && data[this.dynaDefProps.children].length > 0
        }
    },
    // --------------------------------------------------- Created函数 --------------------------------------------------
    created() {
        // 获取输入框宽度同步至树状菜单宽度
        this.$nextTick(() => {
            this.treeWidth = `${(this.width || this.$refs.select.$refs.reference.$el.clientWidth) - 24}px`;
    });
    }
});
