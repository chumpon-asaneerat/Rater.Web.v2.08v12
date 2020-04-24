<card-container>
    <div class="card-container-wrapper">
        <yield/>
    </div>
    <style>
        :scope {
            position: relative;
            display: grid;
            grid-template-columns: 1fr;
            grid-template-rows: 1fr;
            grid-template-areas: 
                'card-container-area';
            margin: 0;
            padding: 5px;
            padding-right: 10px;
            width: 100%;
            height: 100%;
        }
        :scope>.card-container-wrapper {
            grid-area: card-container-area;
            position: relative;
            margin: 0;
            padding: 0;
            width: 100%;
            height: 100%;
        }
        :scope[shadow]>.card-container-wrapper {
            border: 1px solid #EEEEEE;
            box-shadow: var(--card-box-shadow);
        }
    </style>
</card-container>