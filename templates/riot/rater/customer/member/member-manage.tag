<member-manage>
    <dual-layout ref="layout">
        <yield to="left-panel">
            <member-view ref="leftpanel" class="view"></member-view>
        </yield>
        <yield to="right-panel">
            <member-editor ref="rightpanel" class="entry"></member-editor>
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

        let addEvt = events.doc.add, delEvt = events.doc.remove
        let bindEvents = () => { }
        let unbindEvents = () => { }

        this.toggle = () => {
            // toggle screen.
            layout.toggle()
        }
        this.setup = () => {}
        this.refresh = () => {}
    </script>
</member-manage>