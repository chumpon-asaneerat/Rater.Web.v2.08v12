<card-item>
    <div class="card-item-wrapper">
        <yield />
    </div>
    <style>
        :scope {
            position: relative;
            display: inline-block;
            margin: 0;
            padding: 2px;
            padding-bottom: 15px;
        }
        :scope>.card-item-wrapper {
            position: relative;
            display: block;
            margin: 0 auto;
            padding: 5px;
            width: 100%;
            height: 100%;
        }
        :scope[shadow]>.card-item-wrapper {
            border: 1px solid #EEEEEE;
            box-shadow: var(--card-box-shadow);
        }
    </style>
</card-item>