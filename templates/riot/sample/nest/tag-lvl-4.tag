<tag-lvl-4>
    <yield />
    <style>
        :scope {
            position: relative;
            display: block;
            margin: 0 auto;
            padding: 5px;
            background-color: lightblue;
        }
    </style>
    <script>
        let self = this

        this.on('mount', () => {
            console.log(self.__.tagName, ' mounted.')
        })
    </script>
</tag-lvl-4>