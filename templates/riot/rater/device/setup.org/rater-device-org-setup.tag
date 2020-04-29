<rater-device-org-setup>
    <h3>Setup Organization</h3>
    <style>
        :scope {
            position: relative;
            display: block;
            margin: 0 auto;
            padding: 0;
            width: 100%;
            height: 100%;
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

        let initCtrls = () => { }
        let freeCtrls = () => { }
        let bindEvents = () => { }
        let unbindEvents = () => { }
    </script>
</rater-device-org-setup>