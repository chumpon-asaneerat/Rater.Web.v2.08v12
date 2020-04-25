<dual-layout>
    <div ref="flipper" class="dual-layout-container">
        <div class="left-block">
            <div class="content">
                <yield from="left-panel"></yield>
            </div>
        </div>
        <div class="right-block">
            <div class="content">
                <yield from="right-panel"></yield>
            </div>
        </div>
    </div>
    <style>
        :scope {
            position: relative;
            display: grid;
            grid-template-columns: 1fr;
            grid-template-rows: 1fr;
            grid-template-areas: 
                'dual-area';
            margin: 0;
            padding: 5px;
            padding-right: 10px;
            width: 100%;
            height: 100%;
            overflow: hidden;
        }
        :scope>.dual-layout-container {
            grid-area: dual-area;
            position: relative;
            display: block;
            margin: 0;
            padding: 0;
            width: 100%;
            height: 100%;
            overflow: hidden;
        }
        :scope>.dual-layout-container.toggle {
            transform: none;
        }
        /* for device width 700px and up */
        @media only screen and (min-width: 700px) {
            :scope>.dual-layout-container {
                grid-area: dual-area;
                position: relative;
                display: grid;
                grid-template-columns: 1fr 1fr;
                grid-template-rows: 1fr;
                grid-template-areas: 
                    'left-area right-area';
                margin: 0;
                padding: 0;
                width: 100%;
                height: 100%;
                overflow: hidden;
            }
        }
        :scope[shadow].dual-layout-container {
            /* border: 1px solid #EEEEEE; */
            box-shadow: var(--card-box-shadow);
        }
        :scope>.dual-layout-container .left-block, 
        :scope>.dual-layout-container .right-block{
            position: absolute;
            display: inline-block;
            opacity: 1;
            margin: 0;
            padding: 0;
            width: 100%;
            height: 100%;
            overflow: hidden;
            /*
            transform-style: preserve-3d;
            backface-visibility: hidden;
            */
        }
        :scope>.dual-layout-container .left-block {
            /* display: inline-block; */
            transition: opacity 1s ease-in-out;
            opacity: 1;
            /* transform: rotateY(0deg); */
        }
        :scope>.dual-layout-container.toggle .left-block {
            /* display: none; */
            transition: opacity .5s ease-in-out;
            opacity: 0;
            /* transform: rotateY(180deg); */
        }
        :scope>.dual-layout-container .right-block {
            /* display: none; */
            opacity: 0;
            transition: opacity .5s ease-in-out;
            /* transform: rotateY(180deg); */
        }
        :scope>.dual-layout-container.toggle .right-block {
            /* display: inline-block; */
            transition: opacity 1s ease-in-out;
            opacity: 1;
            /* transform: rotateY(0deg); */
        }
        :scope>.dual-layout-container .left-block .content,
        :scope>.dual-layout-container .right-block .content {
            position: relative;
            display: inline-block;
            margin: 0 auto;
            padding: 0;
            width: 100%;
            height: 100%;
            overflow: hidden;
        }
        @media only screen and (min-width: 720px) {
            :scope>.dual-layout-container .left-block,
            :scope>.dual-layout-container .right-block,
            :scope>.dual-layout-container.toggle .left-block,
            :scope>.dual-layout-container.toggle .right-block {
                opacity: 1;
                backface-visibility: initial;
                transform-style: initial;
                transform: none;
            }
            :scope>.dual-layout-container .left-block {
                grid-area: left-area;
            }
            :scope>.dual-layout-container .right-block {
                grid-area: right-area;
            }
        }
    </style>
    <script>
        let self = this;

        this.on('mount', () => {
            flipper = self.refs['flipper']
        })
        this.on('unmount', () => {
            flipper = null
        })

        this.toggle = () => {
            flipper.classList.toggle('toggle');
        }
    </script>
</dual-layout>