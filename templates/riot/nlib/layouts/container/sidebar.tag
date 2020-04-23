<sidebar>
    <yield/>
    <style>
        :scope {
            position: relative;
            display: inline-block;
            margin: 0;
            padding: 0;
            width: 300px;
            height: calc(100% - 3px);
            /*
            width: 300px;
            height: calc(100% - 3px);
            */
            border: 1px solid black;
        }
        :scope.c1 {
            background-color: burlywood;
        }
        :scope.c2 {
            background-color: aliceblue;
        }
        :scope.c3 {
            background-color: cornsilk;
        }
    </style>
    <script>
        let self = this
        let addEvt = events.doc.add, delEvt = events.doc.remove
    </script>
</sidebar>