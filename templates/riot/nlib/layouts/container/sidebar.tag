<sidebar>
    <yield/>
    <style>
        :scope {
            /* position: absolute; */
            display: inline-block;
            margin: 0;
            /*
            left: 0;
            top: 0;
            bottom: 0;
            */
            width: 300px;
            height: calc(100% - 0px);
            background-color: burlywood;
            border: 1px solid black;
        }
    </style>
    <script>
        let self = this
        let addEvt = events.doc.add, delEvt = events.doc.remove
    </script>
</sidebar>