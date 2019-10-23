<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <!-- import CSS -->
    <link rel="stylesheet" href="https://unpkg.com/element-ui/lib/theme-chalk/index.css">
    <jsp:include page="/resources/vue.jsp" flush="true"/>
</head>
<body>
<div id="app">
    <template v-cloak>
        <el-container>
            <el-main>
                <el-row>

                                    <el-form-item>
                                        <el-button type="primary" icon="el-icon-search" @click="searchMit()"
                                                   :loading="searchLoading">搜索
                                        </el-button>
                                    </el-form-item>

                </el-row>



            </el-main>
        </el-container>
    </template>
</div>
</body>
<!-- import Vue before Element -->
<script src="https://unpkg.com/vue/dist/vue.js"></script>
<!-- import JavaScript -->
<script src="https://unpkg.com/element-ui/lib/index.js"></script>
<script>
    new Vue({
        el: '#app',
        data() {
            var _$this = this;
            return {
                customerList: [],//所有的项目编码-客户名称
                updateLoading: false,
                formLabelWidth: '150px',
                submitLoading: false,//新增时提交loading
                productArr: [
                    {id: "1", name: "模管家大系统"},
                    {id: "2", name: "模管家小系统"},
                    {id: "3", name: "模保易"},
                    {id: "4", name: "模房网"},
                ],
                multipleSelection: [],
                responsibleList: [],//存放负责人的数组
                // 1:制定方案，2：讨论方案，3：方案签字，4：功能开发，5：功能测试，6：功能更新，7：用户培训，8：客户试用,9:全面上线，10：验收签字',
                taskTypeArray: [
                    {id: "1", name: "制定方案"},
                    {id: "2", name: "讨论方案"},
                    {id: "3", name: "方案签字"},
                    {id: "4", name: "功能开发"},
                    {id: "5", name: "功能测试"},
                    {id: "6", name: "功能更新"},
                    {id: "7", name: "用户培训"},
                    {id: "8", name: "客户试用"},
                    {id: "9", name: "全面上线"},
                    {id: "10", name: "验收签字"},
                ],
                //存放状态的数组
                // 状态；0：新，1：进行中，2：暂停，3：完成
                statusArray: [
                    {id: "0", name: "新"},
                    {id: "1", name: "进行中"},
                    {id: "2", name: "暂停"},
                    {id: "3", name: "完成"},
                ],
                typeArr: [
                    {id: "1", name: "标配"},
                    {id: "2", name: "产品改版/升级"},
                    {id: "3", name: "产品优化"},
                    {id: "4", name: "国际化"},
                    {id: "5", name: "物联网"},
                    {id: "6", name: "客制"},
                    {id: "7", name: "接口"},
                    {id: "8", name: "bug"},
                    {id: "9", name: "内部管理"},
                    {id: "10", name: "大数据分析"},
                ],
                taskArr: [
                    {id: "1", name: "制定方案"},
                    {id: "2", name: "讨论方案"},
                    {id: "3", name: "方案签字"},
                    {id: "4", name: "功能开发"},
                    {id: "5", name: "功能测试"},
                    {id: "6", name: "功能更新"},
                    {id: "7", name: "用户培训"},
                    {id: "8", name: "客户试用"},
                    {id: "9", name: "全面上线"},
                    {id: "10", name: "验收签字"},
                ],
                dateTitleList: [],//用于遍历table的列数
                downLoadHtmlSrc: '',//用于接收iframe下载页面
                uploadHtmlSrc: '',//用于接收iframe嵌套页面
                uploadDialogVisible: false,//上传文档
                downLoadDialogVisible: false,//下载文档
                detailDialogVisible: false,//明细弹框
                searchLoading: false,
                searchLabelWidth: '120',
                searchForm: {
                    projectName: '',//项目名称
                    taskTypeId: '',//项目阶段
                    customerName: '',//客户名称
                    responsibleId: '',//负责人ID
                    schEndTime: '',//计划完成时间
                    status: '',//状态；0：新，1：进行中，2：暂停，3：完成
                },
                unfinishedWorkList: [],//用于存放未完成工作的列表
                detailData: {
                    realname: '',
                    minPlantStartTime: '',
                    maxPlantFinishTime: '',
                },
                projectTableData: [],
                tableHeight: '',
                projectTableLoading: false,
                projectTotal: 5,
                projectCurrentPage: 1,
                projectPageSize: 10,
                //未完成工作进度明细
                processTotal: 5,
                processCurrentPage: 1,
                processPageSize: 10,


                createDialogVisible: false,
                //新增的数据
                createForm: {
                    projectId: '',//项目编码
                    taskTypeId: '',//项目阶段
                    description: '',//开发内容
                    schStartTime: '',//计划开始时间
                    schEndTime: '',//计划完成时间
                    schHours: '',//计划工时
                    taskResponsibleId: '',//创建人负责人
                },
                detailsList: [],
                taskList: [],
                taskTableData: [],
                taskTableLoading: false,
                //校验
                createFormRules: {
                    projectId: [
                        {required: true, message: '必填项', trigger: ['blur', 'change']},
                    ],
                    taskTypeId: [
                        {required: true, message: '必填项', trigger: ['blur', 'change']}
                    ],

                    schStartTime: [
                        {required: true, message: '必填项', trigger: ['blur', 'change']}
                    ],
                    schEndTime: [
                        {required: true, message: '必填项', trigger: ['blur', 'change']}],
                    schHours: [
                        {required: true, message: '必填项', trigger: ['blur', 'change']}],
                    taskResponsibleId: [
                        {required: true, message: '必填项', trigger: ['blur', 'change']}],
                },
                //日期快捷键
                pickerOptions: {
                    //设置不可选的时间范围
                    disabledDate(time) {
                        return time.getTime() < Date.now();
                    },
                    shortcuts: [{
                        text: '今天',
                        onClick(picker) {
                            picker.$emit('pick', new Date());
                        }
                    }, {
                        text: '明天',
                        onClick(picker) {
                            const date = new Date();
                            date.setTime(date.getTime() + 3600 * 1000 * 24);
                            picker.$emit('pick', date);
                        }
                    }, {
                        text: '后天',
                        onClick(picker) {
                            const date = new Date();
                            date.setTime(date.getTime() + 3600 * 1000 * 24 * 2);
                            picker.$emit('pick', date);
                        }
                    }, {
                        text: '一周后',
                        onClick(picker) {
                            const date = new Date();
                            date.setTime(date.getTime() + 3600 * 1000 * 24 * 7);
                            picker.$emit('pick', date);
                        }
                    }]
                },
                //计划开始日期快捷键
                startPickerOptions: {
                    //设置不可选的时间范围
                    disabledDate(time) {
                        if (_$this.createForm.schEndTime) {
                            var schEndTime = _$this.createForm.schEndTime;
                            try {
                                return time.getTime() > (schEndTime.getTime() - 3600 * 1000 * 24 * 1);

                            } catch (e) {

                            }
                        }
                    },
                    shortcuts: [{
                        text: '今天',
                        onClick(picker) {
                            picker.$emit('pick', new Date());
                        }
                    }, {
                        text: '明天',
                        onClick(picker) {
                            const date = new Date();
                            date.setTime(date.getTime() + 3600 * 1000 * 24);
                            picker.$emit('pick', date);
                        }
                    }, {
                        text: '后天',
                        onClick(picker) {
                            const date = new Date();
                            date.setTime(date.getTime() + 3600 * 1000 * 24 * 2);
                            picker.$emit('pick', date);
                        }
                    }, {
                        text: '一周后',
                        onClick(picker) {
                            const date = new Date();
                            date.setTime(date.getTime() + 3600 * 1000 * 24 * 7);
                            picker.$emit('pick', date);
                        }
                    }]
                },
                //计划完成日期快捷键
                endPickerOptions: {
                    //设置不可选的时间范围
                    shortcuts: [{
                        text: '今天',
                        onClick(picker) {
                            picker.$emit('pick', new Date());
                        }
                    }, {
                        text: '明天',
                        onClick(picker) {
                            const date = new Date();
                            date.setTime(date.getTime() + 3600 * 1000 * 24);
                            picker.$emit('pick', date);
                        }
                    }, {
                        text: '后天',
                        onClick(picker) {
                            const date = new Date();
                            date.setTime(date.getTime() + 3600 * 1000 * 24 * 2);
                            picker.$emit('pick', date);
                        }
                    }, {
                        text: '一周后',
                        onClick(picker) {
                            const date = new Date();
                            date.setTime(date.getTime() + 3600 * 1000 * 24 * 7);
                            picker.$emit('pick', date);
                        }
                    }]
                },
                tasks:[],
                loading:false
            }
        },
        mounted: function () {
            //初始化
            this.initSome();
            //初始化未完成的工作进度明细
            this.progressWork();
            //初始化项目编码-客户名称
            this.getCustomer();
            this.searchMit();

            //初始化 高度
            this.$refs.container.style.height = (window.innerHeight - 80) + 'px'
            this.$refs.gantt.style.height = (window.innerHeight - 80) + 'px'
            //初始化 左边侧栏信息
            gantt.config.columns = [{// 初始化列
                name: "projectName",
                label: "<div class='searchEl'>项目名称</div>",
                tree: true,
                width: 100
                // editor: textEditor
            },
                {// 初始化列
                    name: "text",
                    label: "<div class='searchEl'>项目阶段</div>",
                    tree: true,
                    width: 100
                    // editor: textEditor
                },
                {// 初始化列
                    name: "userName",
                    label: "<div class='searchEl'>负责人</div>",
                    tree: true,
                    width:100
                    // editor: textEditor
                },
                {name: "start_date", label: "<spring:message code="schStartTime"/>", align: "center" ,     width:100},
                {name: "duration", label: "时长", align: "center",     width:50},
                // {name:"add",        label:"" },
            ];
            //设置基本信息
            gantt.locale.labels.baseline_enable_button = '设置';
            gantt.locale.labels.baseline_disable_button = '隐藏';
            gantt.locale.labels.link_start = '计划时间';
            gantt.locale.labels.section_description = "设备名称"
            gantt.config.scale_unit = "day";
            gantt.config.date_scale = "%d";
            gantt.config.min_column_width = 100;
            gantt.config.duration_unit = "day";
            gantt.config.scale_height = 20 * 3;
            gantt.config.row_height = 28;
            gantt.config.task_height = 16;
            gantt.config.row_height = 40;


            //设置表头的日期展示模板
            var weekScaleTemplate = function (date) {
                var dateToStr = gantt.date.date_to_str("%d %M");
                var weekNum = gantt.date.date_to_str("(week %W)");
                var endDate = gantt.date.add(gantt.date.add(date, 1, "week"), -1, "day");
                return dateToStr(date) + " - " + dateToStr(endDate) + " " + weekNum(date);
            };

            //设置表头的日期展示
            gantt.config.subscales = [{
                unit: "month",
                step: 1,
                date: "%F, %Y"
            }, {
                unit: "week",
                step: 1,
                template: weekScaleTemplate
            },
            ];

            gantt.config.details_on_dblclick = false;
            gantt.locale.labels.section_baseline = "计划时间";

            gantt.locale.labels.section_template = "Details";

            //设置计划时间的进度条
            gantt.addTaskLayer(function draw_planned(task) {
                if (task.planned_start) {
                    var sizes = gantt.getTaskPosition(task, task.planned_start, task.planned_end);
                    var el = document.createElement('div');
                    el.className = 'baseline';
                    el.style.left = sizes.left + 'px';
                    el.style.width = sizes.width + 'px';
                    el.style.top = sizes.top + gantt.config.task_height + 13 + 'px';
                    return el;
                }
                return false;
            });
            //设置样式
            gantt.templates.task_class = function (start, end, task) {
                if (task.planned_end) {
                    var classes = ['has-baseline'];
                    if (end.getTime() > task.planned_end.getTime()) {
                        classes.push('overdue');
                    }
                    return classes.join(' ');
                }else {
                    if (task.end_date) {
                        if (end.getTime() > task.end_date.getTime()) {
                            var overdue = Math.ceil(Math.abs((end.getTime() - task.end_date.getTime()) / (24 * 60 * 60 * 1000)));
                            var priority = 3;
                            if(overdue==0) {
                                priority = 2
                            }else if(overdue>0){
                                priority = 1
                            }else {
                                priority = 3
                            }
                            switch (priority){
                                case "1":
                                    return "high";
                                    break;
                                case "2":
                                    return "medium";
                                    break;
                                case "3":
                                    return "low";
                                    break;
                            }
                        }
                    }
                }
            };

            //设置延迟
            gantt.templates.rightside_text = function (start, end, task) {
                if (task.end_date) {
                    if (end.getTime() > task.end_date.getTime()) {
                        var overdue = Math.ceil(Math.abs((end.getTime() - task.end_date.getTime()) / (24 * 60 * 60 * 1000)));
                        var text = "<b>延迟: " + overdue + " 天</b>";
                        return text;
                    }
                }
            };

            //设置tooltip
            gantt.templates.tooltip_text = function (start, end, task) {
                return "<b>工作内容:</b> " + task.description +
                    "<br/><b>工作阶段:</b> " + task.text  +
                    "<br/><b>负责人:</b> " + task.userName  +
                    "<br/><b>计划开始时间:</b> " + gantt.templates.tooltip_date_format(start) +
                    "<br/><b>计划完成时间:</b> " + gantt.templates.tooltip_date_format(end)  +
                    "<br/><b>计划工时(H):</b> " + (null==task.schtotaltime?0:task.schtotaltime)+
                    "<br/><b>实际开始时间:</b> " + ((null==task.planned_start || task.planned_start=="")?"":new Date(task.planned_start).format("yyyy-MM-dd"))+
                    "<br/><b>实际完成时间:</b> " + (task.flag==1?((null==task.planned_end|| task.planned_end =="")?"":new Date(task.planned_end).format("yyyy-MM-dd")):'') +
                    "<br/><b>实际工时(H):</b> " + (null==task.achtotaltime?0:task.achtotaltime);
            };

            //格式化 计划时间
            gantt.attachEvent("onTaskLoading", function (task) {
                task.planned_start = gantt.date.parseDate(task.planned_start, "xml_date");
                task.planned_end = gantt.date.parseDate(task.planned_end, "xml_date");
                return true;
            });
            //加入行事历
            var johnCalendarId = gantt.addCalendar({
                worktime: {
                    days: [0, 1, 1, 1, 1, 1, 0]
                }
            });

            gantt.config.resource_calendars = {
                "user": {
                    1: johnCalendarId,
                    // 2: mikeCalendarId,
                    // 3: annaCalendarId
                }
            };
            gantt.templates.timeline_cell_class = function (task, date) {
                if (!gantt.isWorkTime({date: date, task: task}))
                    return "week_end";
                return "";
            };


            gantt.init(this.$refs.gantt)
            gantt.parse(this.tasks)

            // //显示 当前时间线
            // var date_to_str = gantt.date.date_to_str(gantt.config.task_date);
            // setInterval(function () {
            //     //今日竖线
            //     var today = new Date();
            //     gantt.addMarker({
            //         start_date: today,
            //         css: "today",
            //         text: "当前时间",
            //         title: "当前时间: " + date_to_str(today)
            //     });
            // }, 1000 * 20);
            gantt.attachEvent('onAfterTaskAdd', (id, task) => {
                this.$emit('task-updated', id, 'inserted', task)
            })

            gantt.attachEvent('onAfterTaskUpdate', (id, task) => {
                this.$emit('task-updated', id, 'updated', task)
            })

            gantt.attachEvent('onAfterTaskDelete', (id) => {
                this.$emit('task-updated', id, 'deleted')
                if (!gantt.getSelectedId()) {
                this.$emit('task-selected', null)
            }
        })
            gantt.attachEvent('onAfterLinkAdd', (id, link) => {
                this.$emit('link-updated', id, 'inserted', link)
            })

            gantt.attachEvent('onAfterLinkUpdate', (id, link) => {
                this.$emit('link-updated', id, 'updated', link)
            })

            gantt.attachEvent('onAfterLinkDelete', (id, link) => {
                this.$emit('link-updated', id, 'deleted')
            })
            gantt.attachEvent('onTaskSelected', (id) => {
                let task = gantt.getTask(id)
                this.selectedTask = task
                this.$set(this.selectedTask)
                this.$emit('task-selected', task)
            })

            gantt.attachEvent('onAfterTaskAdd', (id, task) => {
                this.$emit('task-updated', id, 'inserted', task)
                task.progress = task.progress || 0
                if (gantt.getSelectedId() == id) {
                this.$emit('task-selected', task)
            }
        })

            gantt.attachEvent('onAfterTaskUpdate', (id, task) => {
                this.$emit('task-updated', id, 'updated', task)
            })

            gantt.attachEvent('onAfterTaskDelete', (id) => {
                this.$emit('task-updated', id, 'deleted')
                if (!gantt.getSelectedId()) {
                this.$emit('task-selected', null)
            }
        })

            gantt.attachEvent('onAfterLinkAdd', (id, link) => {
                this.$emit('link-updated', id, 'inserted', link)
            })

            gantt.attachEvent('onAfterLinkUpdate', (id, link) => {
                this.$emit('link-updated', id, 'updated', link)
            })

            gantt.attachEvent('onAfterLinkDelete', (id, link) => {
                this.$emit('link-updated', id, 'deleted')
            })
        },
        created: function () {
            var id = ${id};
            this.searchForm.responsibleId = id;//默认将登录者设为负责人
            this.tableHeight = getHeight() - 150;
        },
        methods: {
            speedFormat(row, column, cellValue, index) {
                if (row.actEndTime) {//若实际完成时间不为空，若实际完成时间大于计划完成时间，则返回按时，否则返回延期
                    if(row.schEndTime>row.actEndTime){
                        return '按时'
                    }else {
                        return '延期'
                    }
                    return "收费";
                } else {
                    //若实际完成时间为空，则实际new Date()小于计划完成时间，则按时，否则延期
                    var currentTime = new Date().getTime();
                    if(currentTime>row.schEndTime){
                        return '延期';
                    }else {
                        return '按时';
                    }
                    return "免费";
                }
            },
            schHoursChange(value) {
                this.createForm.schHours = value;
            },
            getCustomer() {
                var _$this = this;
                $.ajax({
                    type: 'POST',
                    url: '${basePath}/manage/upmsMytask/getCustomers',
                    // data: param,
                    async: false,// Must be false, otherwise loadBranch happens after showChildren?
                    dataType: 'json',
                    // contentType: "text/plain;charset=utf-8",
                    beforeSend: function () {
                        // _$this.updateLoading = true;
                    },
                    success: function (result) {
                        if (result.success) {
                            _$this.customerList = result.data;
                        }
                    },
                    error: function (XMLHttpRequest, textStatus, errorThrown) {
                    }
                });

            },
            progressWork() {
                var _$this = this;
                $.ajax({
                    type: 'POST',
                    url: '${basePath}/manage/upmsMytask/getUnfinishedWorkList',
                    // data: param,
                    async: false,// Must be false, otherwise loadBranch happens after showChildren?
                    dataType: 'json',
                    // contentType: "text/plain;charset=utf-8",
                    beforeSend: function () {
                        // _$this.updateLoading = true;
                    },
                    success: function (result) {
                        if (result.success) {
                            var unfinishedWorkList = result.data;
                            _$this.unfinishedWorkList = unfinishedWorkList;
                            for (var i = 0; i < unfinishedWorkList.length; i++) {
                                var childList = unfinishedWorkList[i].childList;
                                for (var j = 0; j < childList.length; j++) {
                                    for (var prop in childList[j]) {
                                        if (childList[j].hasOwnProperty(prop)) {
                                            unfinishedWorkList[i].children[j][prop] = childList[j][prop];
                                        }
                                    }
                                }
                            }

                            if (unfinishedWorkList.length !=0 && unfinishedWorkList[0].dateTitleList) {
                                _$this.dateTitleList = unfinishedWorkList[0].dateTitleList;
                            }
                        }
                    },
                    error: function (XMLHttpRequest, textStatus, errorThrown) {
                    }
                });
            },
            openDetailDialog(row) {
                var _$this = this;
                var param = new Object();
                var map = new Object();
                map.taskResponsibleId = row.taskResponsibleId;
                map.taskId = row.id;
                param.map = map;
                $.ajax({
                    type: 'POST',
                    url: '${basePath}/manage/upmsMytask/getDetailsList',
                    data: param,
                    async: false,// Must be false, otherwise loadBranch happens after showChildren?
                    dataType: 'json',
                    // contentType: "text/plain;charset=utf-8",
                    beforeSend: function () {
                        // _$this.updateLoading = true;
                    },
                    success: function (result) {
                        if (result.success) {
                            var detailsList = result.data[0];
                            _$this.detailsList = detailsList;
                            var taskList = detailsList.taskList;
                            for(var i=0;i<taskList.length;i++){
                                taskList[i].realname=detailsList.realname;
                            }
                            _$this.taskList = taskList;
                            _$this.detailDialogVisible = true;
                        } else {
                            _$this.updateLoading = false;
                            _$this.$message.error(result.msg)
                        }
                        // _$this.searchMit();
                    },
                    error: function (XMLHttpRequest, textStatus, errorThrown) {
                    }
                });
            },
            taskIndex(index) {
                return index + (this.projectCurrentPage - 1) * 10 + 1;
            },
            handleSelectionChange(val) {
                this.multipleSelection = val;
            },
            handleUpload(index, row) {
                //打开上传dialog
                this.uploadDialogVisible = true;
                this.uploadHtmlSrc = '${basePath}/manage/upmsMytask/fileUpload/' + row.id;
            },
            handleDownLoad(index, row) {
                //打开下载dialog
                this.downLoadDialogVisible = true;
                this.downLoadHtmlSrc = '${basePath}/manage/upmsMytask/fileDown/' + row.id;
            },
            alertMsg(errorArr, color) {
                const h = this.$createElement;
                this.$notify.info({
                    title: '<spring:message code="remind"/> ',
                    message: h('div', {style: 'color:' + color}, errorArr),
                    duration: 3000,
                });
            },
            updateTask(row, status) {
                var _$this = this;
                if (status == null || status == '') {
                    _$this.alertMsg(["至少选择一条数据！"], 'red');
                    return;
                }
                //如果该任务已完成
                if (row.status == 3 && (status == 1 || status == 2 || status == 3)) {
                    _$this.alertMsg(["该任务已完成，不可开启或暂停！"], 'red');
                    return;
                }
                //只有自己可以删除自己创建的任务
                if ((row.cby != ${id}) && status == 4) {
                    _$this.alertMsg(["只有创建人可以删除该任务！"], 'red');
                    return;
                }
                <%--                                            状态；0：新，1：进行中，2：暂停，3：完成--%>

                //此任务正在进行中,无法再次开始
                if (row.status == 1 && status == 1) {
                    _$this.alertMsg(["此任务正在进行中,无法再次开始！"], 'red');
                    return;
                }

                //此任务正在进行中,无法再次开始
                if (row.status == 2 && status == 2) {
                    _$this.alertMsg(["此任务已被暂停，不可再次暂停！"], 'red');
                    return;
                }
                //此任务正在进行中,无法再次开始
                if (row.status == 1 && status == 1) {
                    _$this.alertMsg(["此任务正在进行中,无法再次开始！"], 'red');
                    return;
                }

                //若任务未开始，则不可点击暂停,完成
                if (row.status == 0 && status == 2) {
                    _$this.alertMsg(["此任务还未开始,无法暂停！"], 'red');
                    return;
                }
                if (row.status == 0 && status == 3) {
                    _$this.alertMsg(["此任务还未开始,无法完成！"], 'red');
                    return;
                }
                var param = new Object();
                var map = new Object();
                map.id = row.id;
                map.status = status;
                param.map = map;
                var msg = "";
                if (status == 1) {
                    msg = "确认开始";
                } else if (status == 2) {
                    msg = "确认暂停";
                } else if (status == 3) {
                    msg = "确认完成";
                } else if (status == 4) {
                    msg = "确认删除";
                }
                this.$confirm(msg, '提醒 ', {
                    confirmButtonText: '确定',
                    cancelButtonText: '取消',
                    type: 'warning'
                }).then(() => {
                    $.ajax({
                        type: 'POST',
                        url: '${basePath}/manage/upmsMytask/update',
                        data: param,
                        async: false,// Must be false, otherwise loadBranch happens after showChildren?
                        dataType: 'json',
                        // contentType: "text/plain;charset=utf-8",
                        beforeSend: function () {
                            _$this.updateLoading = true;
                        },
                        success: function (result) {
                            if (result.success) {
                                _$this.updateLoading = false;
                                _$this.$message.success(result.msg)
                            } else {
                                _$this.updateLoading = false;
                                _$this.$message.error(result.msg)
                            }
                            _$this.searchMit();
                        },
                        error: function (XMLHttpRequest, textStatus, errorThrown) {
                        }
                    });

            }).catch(() => {
                    this.$message({
                        type: 'info',
                        message: '已取消刪除'
                    });
            });


            },
            dateFormat(row, column, cellValue, index) {
                if (cellValue) {
                    return row.id;
                }
            },
            productFormat(row, column, cellValue, index) {
                if (cellValue == 1) {
                    return "模管家大系统"
                } else if (cellValue == 2) {
                    return "模管家小系统"
                } else if (cellValue == 3) {
                    return "模保易"
                } else if (cellValue == 4) {
                    return "模房网"
                }
            },
            taskFormat(row, column, cellValue, index) {
                switch (cellValue) {
                    case '1':
                        return "制定方案"
                        break;
                    case '2':
                        return "讨论方案"
                        break;
                    case '3':
                        return "方案签字"
                        break;
                    case '4':
                        return "功能开发"
                        break;
                    case '5':
                        return "功能测试"
                        break;
                    case '6':
                        return "功能更新"
                        break;
                    case '7':
                        return "用户培训"
                        break;
                    case '8':
                        return "客户试用"
                        break;
                    case '9':
                        return "全面上线"
                        break;
                    case '10':
                        return "验收签字"
                        break;
                }
            },

            // \1:制定方案，2：讨论方案，3：方案签字，4：功能开发，5：功能测试，6：功能更新，7：用户培训，8：客户试用,9:全面上线，10：验收签字'
            initSome() {
                console.log("初始化List....");
                var _$this = this;
                axios.post('${basePath}/manage/upmsMytask/responsibleList')
                    .then(response => {
                    var res = response.data;
                if (res.success) {
                    _$this.responsibleList = res.data;
                }
            });
            },
            //searchForm搜索
            searchMit() {
                let _$this = this
                var param = new Object();
                var map = new Object();
                map = _$this.searchForm;
                param.map = map;
                param.currentPage = _$this.projectCurrentPage;
                param.pageSize = _$this.projectPageSize;
                _$this.searchLoading = true;
                axios.post('${basePath}/manage/upmsMytask/list', param)
                    .then(result => {
                    var data = result.data;
                if (data) {
                    _$this.projectTableData = data.voList;
                    _$this.projectTotal = data.recordCount;
                    _$this.projectCurrentPage = data.currentPage;

                }
                _$this.searchLoading = false;
            })
            .catch(response => {
                    _$this.searchLoading = false;
            });

                axios.post('${basePath}/manage/upmsMytask/ganttList',param)
                    .then(result => {
                    var data = result.data;
                if (data) {
                    _$this.tasks = data
                    gantt.clearAll();
                    gantt.parse(_$this.tasks);
                    _$this.loading = false;
                }
                _$this.searchLoading = false;
            })
            .catch(response =>{
                    _$this.searchLoading = false;
            });
            },
            projectHandleSizeChange(val) {
                this.projectPageSize = val
                this.searchMit()
            },
            projectHandleCurrentChange(val) {
                this.projectCurrentPage = val
                this.searchMit()
            },
            //未完成工作进度
            processHandleSizeChange(val) {
                this.processPageSize = val;
            },
            processHandleCurrentChange(val) {
                this.processCurrentPage = val;
            },
            //searchForm 时间变化
            searchTimeChange(val) {
                if (null != val && val != '') {
                    this.searchForm.schEndTime = new Date(val.getTime()).format("yyyy-MM-dd");
                } else {
                    this.searchForm.schEndTime = new Date().format("yyyy-MM-dd");
                }
            },
            dateFormat(row, column, cellValue, index) {
                if (cellValue) {
                    return new Date(cellValue).format('yyyy-MM-dd hh:mm:ss');
                }
            },
            productIdsFormat(row, column, cellValue, index) {
                if (cellValue) {
                    var cellValueArr = cellValue.split(',');
                    var returnValue = "";
                    for (var i = 0; i < cellValueArr.length; i++) {
                        returnValue += (this.productArr[(cellValueArr[i] - 1)].name + ",")
                    }
                    return returnValue;
                }
            },
            typeIdsFormat(row, column, cellValue, index) {
                if (cellValue) {
                    var cellValueArr = cellValue.split(',');
                    var returnValue = "";
                    for (var i = 0; i < cellValueArr.length; i++) {
                        returnValue += (this.typeArr[(cellValueArr[i] - 1)].name + ",")
                    }
                    return returnValue;
                }
            },
            feeFlagFormat(row, column, cellValue, index) {
                if (cellValue == "1") {
                    return "是";
                } else {
                    return "否";
                }
            },
            openCreateDialog() {
                //dialog显示出来
                this.createDialogVisible = true;
                //默认值
                // this.createForm.productCheckboxGroup = ["1"];
                // this.createForm.typeCheckboxGroup = ["1"];
                // this.createForm.feeFlag = '1';
                // this.createForm.version = '1';
            },
            taskTableRenderHeader(h, {column}) {
                var _$this = this;
                return h(
                    'div',
                    [
                        h('span', column.label),
                        h('i', {
                            class: 'el-icon-plus',
                            style: 'color:red;margin-left:5px;', on: {
                                click: function () {
                                    _$this.taskTableAddRow();
                                }
                            }
                        })
                    ],
                )
            },
            taskTableAddRow(index, row) {
                var list = {
                    id: Math.random(),
                    taskTypeId: '',
                    description: '',
                    schStartTime: '',
                    schEndTime: '',
                };
                this.taskTableData.push(list);
            },
            createSubmit(formName) {
                this.$refs[formName].validate((valid) => {
                    if (valid) {
                        var param = new Object();
                        var map = new Object();
                        map = this.createForm;
                        if (this.createForm.schStartTime && this.createForm.schEndTime) {
                            map.schStartTime = this.createForm.schStartTime.getTime()
                            map.schEndTime = this.createForm.schEndTime.getTime()
                        }
                        var _$this = this;
                        //将时间转化为时间戳
                        param.map = map;
                        this.submitLoading = true;
                        $.ajax({
                            type: 'POST',
                            url: '${basePath}/manage/upmsMytask/create',
                            data: param,
                            async: false,// Must be false, otherwise loadBranch happens after showChildren?
                            dataType: 'json',
                            // contentType: "text/plain;charset=utf-8",
                            beforeSend: function () {
                                _$this.submitLoading = true;
                            },
                            success: function (result) {
                                if (result.success) {
                                    _$this.$message.success(result.msg)
                                    _$this.submitLoading = false;
                                    _$this.createDialogVisible = false;
                                    _$this.createForm = {};
                                } else {
                                    _$this.$message.error(result.msg)
                                    _$this.submitLoading = false;
                                }
                                _$this.searchMit();
                            },
                            error: function (XMLHttpRequest, textStatus, errorThrown) {
                                // _$this.$message.error(textStatus)
                                // _$this.submitLoading = false
                            }
                        });
                    }
                }
            )
                ;
            },
        }
    });
</script>
</html>
