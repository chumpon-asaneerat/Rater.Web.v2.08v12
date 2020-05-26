<tag-lvl-0>
    <yield />
    <style>
        :scope {
            position: relative;
            display: block;
            margin: 0 auto;
            padding: 5px;
            background-color: beige;
        }
    </style>
    <script>
        let self = this

        this.on('before-mount', () => {
            console.log(self.__.tagName, ' before-mount.')
            riot.eventbus.trigger('update-tag-count')
        })
        this.on('mount', () => {
            console.log(self.__.tagName, ' mounted. group: ', self.opts.group)
            riot.eventbus.trigger('update-tag-mount')
        })
    </script>
</tag-lvl-0>