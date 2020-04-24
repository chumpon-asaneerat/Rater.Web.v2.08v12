<tabcontrol>
    <div class="tabcontrol-wrapper">
        <yield/>
    </div>
    <style>
        :scope {
            position: relative;
            display: grid;
            grid-template-columns: 1fr;
            grid-template-rows: 1fr;
            grid-template-areas: 
                'tabcontrol-wrapper';
            margin: 0;
            padding: 0;
            width: 100%;
            height: 100%;
            overflow: hidden;
            background: transparent;
        }
        :scope>.tabcontrol-wrapper {
            grid-area: tabcontrol-wrapper;
            position: relative;
            display: grid;
            grid-template-columns: 1fr;
            grid-template-rows: auto 1fr;
            grid-template-areas: 
                'tab-headers'
                'tab-pages';
            margin: 0;
            padding: 5px;
            padding-right: 10px;
            width: 100%;
            height: 100%;
            overflow: hidden;
            background: transparent;
        }
        :scope>.tabcontrol-wrapper tabheaders:first-child {
            grid-area: tab-headers;
            position: relative;
            display: inline-block;
            margin: 0;
            padding: 0;
            width: 100%;
            height: 100%;
        }
        :scope>.tabcontrol-wrapper :not(tabheaders:first-child) {
            display: none;
        }
        :scope>.tabcontrol-wrapper tabpages:last-child {
            grid-area: tab-pages;
            position: relative;
            display: inline-block;
            margin: 0;
            padding: 0;
            width: 100%;
            height: 100%;
            box-shadow: var(--tabpages-box-shadow);
        }
        :scope>.tabcontrol-wrapper :not(tabpages:last-child) {
            display: none;
        }
    </style>
    <script>
        let self = this;
        let headers = null;
        let panels = null;

        let initCtrls = () => {
            headers = self.tags['tabheaders']
            panels = self.tags['tabpages']
        }
        let freeCtrls = () => {
            panels = null;
            headers = null;
        }

        this.on('mount', () => { initCtrls(); });
        this.on('unmount', () => { freeCtrls(); });

        updateHeaders = (tabName) => {
            // Get all tabpage and hide them.
            if (headers) {
                headers.show(tabName)
            }
        }

        updatePanels = (tabName) => {
            // Get all tabpage and show if match name.
            if (panels) {
                panels.show(tabName)
            }
        }

        this.setActiveTab = (tabName) => {
            updateHeaders(tabName);
            updatePanels(tabName);
        }
    </script>
</tabcontrol>
