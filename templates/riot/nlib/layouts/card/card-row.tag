<card-row>
    <div class="card-row-wrapper">
        <div class="card-row-area">
            <yield/>
        </div>
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
            height: auto;
        }
        :scope>.card-row-wrapper {
            grid-area: card-row-area;
            position: relative;
            display: block;
            margin: 0 auto;
            padding: 0;
            width: 100%;
            height: auto;
        }
        :scope[shadow]>.card-row-wrapper {
            border: 1px solid #EEEEEE;
            box-shadow: var(--card-box-shadow);
        }
        :scope>.card-row-wrapper>.card-row-area {
            position: relative;
            margin: 0 auto;
            padding: 0;
            width: 100%;
            height: auto;
        }
    </style>
</card-row>