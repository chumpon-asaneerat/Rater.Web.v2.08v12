<mount-container1>
    <yield />
    <style>
    </style>
    <script>
        let self = this

        this.on('mount', () => {
            console.log(self.__.tagName, ' mounted. group: ', self.opts.group)
        })
    </script>
</mount-container1>