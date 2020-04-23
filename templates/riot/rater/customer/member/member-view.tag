<member-view>
    <div ref="container" class="scrarea">
        <div ref="tool" class="toolarea">
            <button class="float-button" onclick="{ addnew }">
                <span class="fas fa-plus">&nbsp;</span>
            </button>
            <button class="float-button" onclick="{ refresh }">
                <span class="fas fa-sync">&nbsp;</span>
            </button>
        </div>
        <div ref="grid" class="gridarea"></div>
    </div>
    <style>
        :scope {
            margin: 0 auto;
            padding: 0;
            width: 100%;
            height: 100%;
            display: grid;
            grid-template-columns: 1fr;
            grid-template-rows: 20px 1fr 20px;
            grid-template-areas:
                '.'
                'scrarea'
                '.'
        }
        :scope>.scrarea {
            grid-area: scrarea;
            display: grid;
            grid-template-columns: 5px auto 1fr;
            grid-template-rows: 1fr;
            grid-template-areas:
                '. toolarea gridarea';
            margin: 0 auto;
            padding: 0;
            margin-top: 3px;
            width: 100%;
            max-width: 800px;
            height: 100%;
        }
        :scope>.scrarea>.toolarea {
            grid-area: toolarea;
            margin: 0 auto;
            margin-right: 5px;
            padding: 0;
            height: 100%;
            overflow: hidden;
            background-color: transparent;
            color: whitesmoke;
        }
        :scope>.scrarea>.toolarea .float-button {
            display: block;
            margin: 0 auto;
            margin-bottom: 5px;
            padding: 3px;
            padding-right: 1px;
            height: 40px;
            width: 40px;
            color: whitesmoke;
            background: silver;
            border: none;
            outline: none;
            border-radius: 50%;
            cursor: pointer;
        }
        :scope>.scrarea>.toolarea .float-button:hover {
            color: whitesmoke;
            background: forestgreen;
        }
        :scope>.scrarea>.gridarea {
            grid-area: gridarea;
            margin: 0 auto;
            padding: 0;
            height: 100%;
            width: 100%;
        }
        :scope .tabulator-row button {
            margin: 0 auto;
            padding: 0px;
            width: 100%;
            font-size: small;
            color: inherit;
            background: transparent;
            border: none;
            outline: none;
            cursor: pointer;
        }
        :scope .tabulator-row button:hover {
            color: forestgreen;
        }
        :scope .tabulator-row button>span {
            margin: 0 auto;
            padding: 0;
        }
    </style>
    <script>
        let self = this;
        let screenId = 'member-view'
        let defaultContent = {
            title: 'Member Management',
            columns: []
        }
        this.content = defaultContent

        let addEvt = events.doc.add, delEvt = events.doc.remove
        this.on('mount', () => {
            initCtrls()
            bindEvents()
        })
        this.on('unmount', () => {
            unbindEvents()
            freeCtrls()
        })
        let initCtrls = () => { initGrid() }
        let freeCtrls = () => { table = null }

        let table
        let initGrid = (data) => {
            let opts = {
                height: "100%",
                layout: "fitDataFill",
                data: (data) ? data : []
            }
            setupColumns(opts)
            table = new Tabulator(self.refs['grid'], opts)
        }
        let setupColumns = (opts) => {
            let = columns = [
                { formatter: editIcon, align:"center", width: 44, 
                    resizable: false, frozen: true, headerSort: false,
                    cellClick: editRow
                },
                { formatter: deleteIcon, align:"center", width: 44, 
                    resizable: false, frozen: true, headerSort: false,
                    cellClick: deleteRow
                }
            ]
            if (self.content && self.content.columns) {
                let cols = self.content.columns
                columns.push(...cols)
            }
            opts.columns = columns
        }
        let datasource
        let syncData = () => {
            if (table) table = null
            let data = (datasource && datasource[lang.langId]) ? datasource[lang.langId] : null
            initGrid(data)
        }
        let editIcon = (cell, formatterParams) => {
            return "<button><span class='fas fa-edit'></span></button>"
        };
        let deleteIcon = (cell, formatterParams) => {
            return "<button><span class='fas fa-trash-alt'></span></button>"
        };

        let bindEvents = () => {
            addEvt(events.name.LanguageChanged, onLanguageChanged)
            addEvt(events.name.ContentChanged, onContentChanged)
            addEvt(events.name.ScreenChanged, onScreenChanged)
            //addEvt(events.name.MemberListChanged, onMemberListChanged)
            //addEvt(events.name.EndEditMember, onEndEdit)
        }
        let unbindEvents = () => {
            //delEvt(events.name.EndEditMember, onEndEdit)
            //delEvt(events.name.MemberListChanged, onMemberListChanged)
            delEvt(events.name.ScreenChanged, onScreenChanged)
            delEvt(events.name.ContentChanged, onContentChanged)
            delEvt(events.name.LanguageChanged, onLanguageChanged)
        }
        let onContentChanged = (e) => { updatecontent(); }
        let onLanguageChanged = (e) => {
            if (screens.is(screenId)) {
                updatecontent(); 
                syncData(); 
            }
        }
        let onScreenChanged = (e) => { 
            if (screens.is(screenId)) {
                updatecontent();
                self.refresh();
            }
        }
        let onMemberListChanged = (e) => {
            /*
            if (screens.is(screenId)) {
                updatecontent();
                syncData(); 
            }
            */
        }

        let editRow = (e, cell) => {
            /*
            let data = cell.getRow().getData();
            events.raise(events.name.BeginEditMember, { item: data })
            */
        }
        let deleteRow = (e, cell) => {
            /*
            let data = cell.getRow().getData();
            console.log('delete:', data, ', langId:', lang.langId);
            syncData();
            */
        }
        let onEndEdit = (e) => {
            /*
            syncData();        
            table.redraw(true);
            */
        }

        let updatecontent = () => {
            if (screens.is(screenId)) {
                let scrContent = contents.getScreenContent()
                self.content = scrContent ? scrContent : defaultContent
                self.update()
                if (table) table.redraw(true)
            }
        }
        this.addnew = (e) => {
            /*
            let data = {
                memberId: null, 
                Prefix: null,
                FirstName: null,
                LastName: null,
                UserName: null,
                Password: null,
                MemberType: 280,
                TagId: null,
                IDCard: null,
                EmployeeCode: null,
            };
            events.raise(events.name.BeginEditMember, { item: data })
            */
        }
        this.refresh = (e) => { 
            let url = '/customer/api/member/search'
            let paramObj = {
                langId: lang.langId
            }
            let fn = (r) => {
                let ret = api.parse(r)
                console.log(ret)
                datasource = ret.records
                syncData()
                updatecontent()
            }
            XHR.get(url, paramObj, fn)
        }
    </script>
</member-view>