<tag-lvl-3>
    <yield />
    <style>
        :scope {
            position: relative;
            display: block;
            margin: 0 auto;
            padding: 5px;
            background-color: oldlace;
        }
    </style>
    <script>
        let self = this

        this.on('mount', () => {
            console.log(self.__.tagName, ' mounted.')
        })
    </script>
</tag-lvl-3>