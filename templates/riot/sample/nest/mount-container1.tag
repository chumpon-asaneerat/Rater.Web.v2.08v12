<mount-container1>
    <yield />
    <style>
    </style>
    <script>
        let self = this
        riot.hook(this)
        /*
        this.on('before-mount', () => {
            console.log(self.__.tagName, ' before-mount.')
            riot.eventbus.trigger('update-tag-count')
        })
        this.on('mount', () => {
            console.log(self.__.tagName, ' mounted. group: ', self.opts.group)
            riot.eventbus.trigger('update-tag-mount')
        })
        */
    </script>
</mount-container1>