<app-signin>
    <div class="content-area">
        <signin ref="signin"></signin>
    </div>
    <style>
        :scope {
            margin: 0 auto;
            padding: 0;
            position: relative;
            width: 100%;
            height: 100%;
            display: grid;
            grid-template-columns: 1fr;
            grid-template-rows: 1fr;
            grid-template-areas: 
                'content-area';
            overflow: hidden;
        }
        :scope>.content-area {
            grid-area: content-area;
            position: relative;
            display: block;
            width: 100%;
            height: 100%;
            overflow: hidden;
        }
    </style>
    <script>
        // for rater app EDL User and Customer Member's signin
        let self = this
        let addEvt = events.doc.add, delEvt = events.doc.remove

        this.on('mount', () => {
            initCtrls()
            bindEvents()
        })
        this.on('unmount', () => {
            unbindEvents()
            freeCtrls()
        })

        let signin
        let initCtrls = () => {
            signin = self.refs['signin']
        }
        let freeCtrls = () => {
            signin = null
        }
        let bindEvents = () => {}
        let unbindEvents = () => {}
    </script>
</app-signin>
