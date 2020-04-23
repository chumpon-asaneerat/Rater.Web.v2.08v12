<member-entry>
    <style>
    </style>
    <script>
        let self = this
        let screenId = 'member-entry'
        let defaultContent = {
            title: 'Member Edit'
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
        }
        )
    </script>
</member-entry>