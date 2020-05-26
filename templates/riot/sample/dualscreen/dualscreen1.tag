<dualscreen1>
    <dual-layout ref="layout">
        <yield to="left-panel">
            <left-screen ref="leftpanel" class="view"></left-screen>
        </yield>
        <yield to="right-panel">
            <right-screen ref="rightpanel" class="entry"></right-screen>
        </yield>
    </dual-layout>
    <style>
        :scope {
            margin: 0;
            padding: 0;
        }
    </style>
    <script>
        let self = this;

        let layout;
        this.on('mount', () => {
            layout = self.refs['layout']
        })
        this.on('unmount', () => {
            layout = null
        })

        this.toggle = () => {
            // toggle screen.
            layout.toggle()
        }
    </script>
</dualscreen1>