<card-item>
    <div class="card-item-wrapper">
        <yield />
    </div>
    <style>
        :scope {
            position: relative;
            display: inline-block;
            margin: 0;
            padding: 4px;
            padding-bottom: 8px;
        }
        :scope>.card-item-wrapper {
            position: relative;
            display: inline-block;
            margin: 0 auto;
            padding: 0;
            width: 100%;
            height: 100%;
        }
        :scope[shadow]>.card-item-wrapper {
            /* border: 1px solid #EEEEEE; */
            box-shadow: var(--card-box-shadow);
        }
    </style>
</card-item>