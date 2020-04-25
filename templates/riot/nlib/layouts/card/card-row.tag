<card-row>
    <div class="card-row-wrapper">
        <yield/>
    </div>
    <style>
        :scope {
            position: relative;
            display: grid;
            grid-template-columns: 1fr;
            grid-template-rows: 1fr;
            grid-template-areas: 
                'card-row-area';
            margin: 0;
            padding: 5px;
            padding-right: 10px;
            width: 100%;
            /* height: 100%; */
            min-height: 200px;
            overflow: hidden;
        }
        :scope>.card-row-wrapper {
            grid-area: card-row-area;
            position: absolute;
            display: flex;
            flex-wrap: wrap;
            justify-content: space-between;
            margin: 0 auto;
            padding: 0;
            width: 100%;
            /*
            height: 100%;
            overflow: auto;
            */
        }
        :scope[shadow]>.card-row-wrapper {
            border: 1px solid #EEEEEE;
            box-shadow: var(--card-box-shadow);
        }
    </style>
</card-row>