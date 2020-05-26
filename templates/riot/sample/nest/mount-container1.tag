<mount-container1>
    <yield />
    <style>
    </style>
    <script>
        let self = this

        this.on('mount', () => {
            console.log(self.__.tagName, ' mounted.')
        })
    </script>
</mount-container1>