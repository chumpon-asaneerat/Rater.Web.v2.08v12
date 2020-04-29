<staff-view>
    <div ref="container" class="scrarea">
        <div class="gridarea">
            <div ref="grid" class="gridwrapper"></div>
        </div>
    </div>
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
        let bindEvents = () => { }
        let unbindEvents = () => { }
    </script>
</staff-view>