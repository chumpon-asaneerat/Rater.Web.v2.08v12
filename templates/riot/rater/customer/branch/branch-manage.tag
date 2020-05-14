<branch-manage>
    <dual-layout ref="layout">
        <yield to="left-panel">
            <branch-view ref="leftpanel" class="view"></branch-view>
        </yield>
        <yield to="right-panel">
            <branch-editor ref="rightpanel" class="entry"></branch-editor>
        </yield>
    </dual-layout>
    <style>
        :scope {
            position: relative;
            display: block;
            margin: 0;
            padding: 0;
            overflow: hidden;
        }
    </style>
    <script>
        let self = this
        let addEvt = events.doc.add, delEvt = events.doc.remove
        let assigns = nlib.utils.assigns

        let screenId = 'branch-manage'
        this.content = {
        }

        this.on('mount', () => {
            initCtrls()
            bindEvents()
        })
        this.on('unmount', () => {
            unbindEvents()
            freeCtrls()
        })

        let layout
        let initCtrls = () => {
            layout = self.refs['layout']
        }
        let freeCtrls = () => {
            layout = null
        }
        let bindEvents = () => { }
        let unbindEvents = () => { }

        this.toggle = () => {
            // toggle screen.
            layout.toggle()
        }
        this.setup = () => {}
        this.refresh = () => {}
    </script>
</branch-manage>