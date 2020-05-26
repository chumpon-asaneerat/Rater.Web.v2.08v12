<right-screen>
    <h2>Right Screen</h2>
    <div class="fake-content"></div>
    <p>Middle of Content.</p>
    <button onclick="{ toggle }">Toggle</button>
    <div class="fake-content"></div>
    <p>End of Content.</p>
    <style>
        :scope {
            position: relative;
            display: block;
            margin: 0;
            padding: 0;
            width: 100%;
            height: 100%;
            border: 1px solid silver;
            background-color: seashell;
            overflow: auto;
        }
        :scope .fake-content {
            height: 300px;
        }
    </style>
    <script>
        let self = this;

        this.toggle = () => {
            self.parent.toggle()
        }
    </script>
</right-screen>