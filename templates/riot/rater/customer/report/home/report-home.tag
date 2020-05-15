<report-home>
    <div ref="container" class="scrarea">
        <div class="menu-area">
            <div class="report-item">
                <button onclick="{ showvotesummary }">
                    <span class="icon fa-3x fas fa-table cr1"></span>
                    <span class="text">{ content.labels.voteSummary }</span>
                </button>
            </div>
            <div class="report-item">
                <button onclick="{ showpiesummary }">
                    <span class="icon fa-3x fas fa-chart-pie cr2"></span>
                    <span class="text">{ content.labels.pieChart }</span>
                </button>
            </div>
            <div class="report-item">
                <button onclick="{ showbarsummary }">
                    <span class="icon fa-3x fas fa-chart-bar cr3"></span>
                    <span class="text">{ content.labels.barChart }</span>
                </button>
            </div>
            <div class="report-item">
                <button onclick="{ showstaffcompare }">
                    <span class="icon fa-3x fas fa-chalkboard-teacher cr6"></span>
                    <span class="text">{ content.labels.staffCompare }</span>
                </button>
            </div>
            <div class="report-item">
                <button onclick="{ showrawvote }">
                    <span class="icon fa-3x fas fa-table cr4"></span>
                    <span class="text">{ content.labels.rawVote }</span>
                </button>
            </div>
            <div class="report-item">
                <button onclick="{ showstaffperf }">
                    <span class="icon fa-3x far fa-id-card cr5"></span>
                    <span class="text">{ content.labels.staffPerf }</span>
                </button>
            </div>
        </div>
    </div>
    <style>
        :scope {
            position: relative;
            display: grid;
            grid-template-columns: 1fr;
            grid-template-rows: 1px 1fr 1px;
            grid-template-areas: 
                '.'
                'scrarea'
                '.';
            margin: 0;
            padding: 0;
            width: 100%;
            height: 100%;
            overflow: hidden;
        }
        :scope>.scrarea {
            grid-area: scrarea;
            display: grid;
            grid-template-columns: 1fr;
            grid-template-rows: 1fr;
            grid-template-areas: 
                'menu-area';
            margin: 0 auto;
            padding: 0;
            width: 100%;
            max-width: 800px;
            height: 100%;
            overflow: hidden;
            box-shadow: var(--default-box-shadow);
        }
        @media (min-width: 620px) {
            :scope>.scrarea>.menu-area {
                column-count: 2;
                column-gap: 20px;
            }
        }
        @media (min-width: 960px) {
            :scope>.scrarea>.menu-area {
                column-count: 3;
                column-gap: 20px;
            }
        }
        :scope>.scrarea>.menu-area {
            grid-area: menu-area;
            margin: 0 auto;
            padding: 20px;
            /* max-width: 1200px; */
            max-width: 1000px;
            /* background-color: aliceblue; */
        }
        :scope>.scrarea>.menu-area .report-item {
            margin: 2px auto;
            padding: 0;
            margin-bottom: 20px;
            width: 200px;
            height: 150px;
            /* background-color: aquamarine; */
            break-inside: avoid;
        }
        :scope>.scrarea>.menu-area .report-item button {
            margin: 0 auto;
            padding: 0;
            display: grid;
            width: 100%;
            height: 100%;
        }
        :scope>.scrarea>.menu-area .report-item button .icon {
            justify-self: center;
            align-self: center;
        }
        :scope>.scrarea>.menu-area .report-item button .text {
            justify-self: center;
            align-self: center;
            font-size: 1rem;
            font-weight: bold;
        }
        :scope>.scrarea>.menu-area .report-item button .icon.cr1 { color: chocolate; }
        :scope>.scrarea>.menu-area .report-item button .icon.cr2 { color: cornflowerblue; }
        :scope>.scrarea>.menu-area .report-item button .icon.cr3 { color: olivedrab; }
        :scope>.scrarea>.menu-area .report-item button .icon.cr4 { color: darkorchid; }
        :scope>.scrarea>.menu-area .report-item button .icon.cr5 { color: sandybrown; }
        :scope>.scrarea>.menu-area .report-item button .icon.cr6 { color: navy; }
    </style>
    <script>
        let self = this
        let addEvt = events.doc.add, delEvt = events.doc.remove
        let assigns = nlib.utils.assigns

        let partId = 'report-home'
        this.content = {
            labels: {
                voteSummary: 'Vote Summary',
                pieChart: 'Pie Chart',
                barChart: 'Bar Chart',
                rawVote: 'Raw Vote',
                staffCompare: 'Staff Compare',
                staffPerf: 'Staff Performance',
                
            }
        }

        this.on('mount', () => {
            initCtrls()
            bindEvents()
        })
        this.on('unmount', () => {
            unbindEvents()
            freeCtrls()
        })

        let initCtrls = () => { }
        let freeCtrls = () => { }
        let bindEvents = () => {
            addEvt(events.name.ContentChanged, onContentChanged)
        }
        let unbindEvents = () => {
            delEvt(events.name.ContentChanged, onContentChanged)
        }

        let onContentChanged = (e) => { updateContents(); }
        let updateContents = () => {
            // sync content by part id.
            let partContent = contents.getPart(partId)
            let propNames = [
                'labels.voteSummary',
                'labels.pieChart',
                'labels.barChart',
                'labels.rawVote',
                'labels.staffCompare',
                'labels.staffPerf'
            ]
            assigns(self.content, partContent, ...propNames)
        }
        this.showpiesummary = () => { 
            let url = '/customer/report/piechart';
            nlib.nav.gotoUrl(url)
        }
        this.showbarsummary = () => { 
            let url = '/customer/report/barchart';
            nlib.nav.gotoUrl(url)
        }
        this.showvotesummary = () => { 
            let url = '/customer/report/votesummary';
            nlib.nav.gotoUrl(url)
        }
        this.showrawvote = () => { 
            let url = '/customer/report/rawvote';
            nlib.nav.gotoUrl(url)
        }
        this.showstaffcompare = () => { 
            let url = '/customer/report/staffcompare';
            nlib.nav.gotoUrl(url)
        }
        this.showstaffperf = () => {             
            let url = '/customer/report/staffperf';
            nlib.nav.gotoUrl(url)
        }
    </script>
</report-home>