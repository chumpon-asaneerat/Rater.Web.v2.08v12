<customer-entry>
    <div class="padtop"></div>
    <div class="padtop"></div>
    <ninput ref="customerName" title="{ content.entry.customerName }" type="text" name="customerName"></ninput>
    <style>
        :scope {
            margin: 0;
            padding: 0;
            width: 100%;
            height: 100%;
        }
        :scope .padtop {
            display: block;
            margin: 0 auto;
            width: 100%;
            min-height: 10px;
        }
    </style>
    <script>
        let self = this
        let addEvt = events.doc.add, delEvt = events.doc.remove
        let assigns = nlib.utils.assigns
        let clone = nlib.utils.clone, equals = nlib.utils.equals

        let partId = 'customer-entry'
        this.content = {
            entry: {
                customerName: 'Customer Name'
            }
        }
        this.isDefault = () => { return (opts.langid === '' || opts.langid === 'EN') }

        this.on('mount', () => {
            initCtrls()
            bindEvents()
        })
        this.on('unmount', () => {
            unbindEvents()
            freeCtrls()
        })

        let custoemrName
        let initCtrls = () => {
            custoemrName = self.refs['custoemrName']
        }
        let freeCtrls = () => {
            custoemrName = null
        }
        let bindEvents = () => {
            addEvt(events.name.ContentChanged, onContentChanged)
        }
        let unbindEvents = () => {
            delEvt(events.name.ContentChanged, onContentChanged)
        }

        let onContentChanged = (e) => { updateContents(); }
        let updateContents = () => {
            // sync content by part id.
            let partContent = contents.getPart(partId)
            let propNames = [
                'entry.customerName'
            ]
            assigns(self.content, partContent, ...propNames)
        }
    </script>
</customer-entry>