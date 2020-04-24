<tabpages>
    <yield />
    <style>
        :scope {
            display: none;
            border: 1px dotted silver;
            overflow: hidden;
        }
        :scope.active { 
            display: block;
            margin: 0;
            padding: 0;
            padding-top: 2px;
            width: 100%;
            height: 100%;
        }
        :scope>:not(tabpage) { display: none; }
    </style>
    <script>
        let self = this;
        let panels = null;

        let initCtrls = () => {
            panels = self.tags['tabpage']
            if (panels && panels.length > 0) panels[0].show();
        }
        let freeCtrls = () => { panels = null; }

        this.on('mount', () => { initCtrls(); });
        this.on('unmount', () => { freeCtrls(); });

        this.show = (tabName) => {
            let activeName = tabName.toLowerCase().trim();
            // Get all tabpage and hide them if not match name.
            for (i = 0; i < panels.length; i++) {
                let panelName = panels[i].getTabName()
                if (panelName === activeName) {
                    panels[i].show();
                }
                else {
                    panels[i].hide();
                }
            }
        }
    </script>
</tabpages>