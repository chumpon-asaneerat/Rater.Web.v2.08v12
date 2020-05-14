<device-entry>
    <div class="padtop"></div>
    <div class="padtop"></div>
    <ninput ref="deviceName" title="{ content.entry.deviceName }" type="text" name="deviceName"></ninput>
    <ninput ref="location" title="{ content.entry.location }" type="text" name="location"></ninput>
    <virtual if={ isDefault() }>
        <nselect ref="deviceTypes" title="{ content.entry.deviceTypeId }"></nselect>
    </virtual>
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

        let partId = 'device-entry'
        this.content = {
            entry: { 
                deviceName: 'Device Name',
                location: 'Location',
                deviceTypeId: 'Type'
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

        let deviceName, location;
        let deviceTypes;
        let initCtrls = () => {
            deviceName = self.refs['deviceName']
            deviceTypes = self.refs['deviceTypes']
            location = self.refs['location']
        }
        let freeCtrls = () => {
            location = null
            deviceTypes = null
            deviceName = null
        }
        let bindEvents = () => {
            addEvt(events.name.ContentChanged, onContentChanged)
        }
        let unbindEvents = () => {
            delEvt(events.name.ContentChanged, onContentChanged)
        }
        let onContentChanged = () => { updateContents() }
        let updateContents = () => {
            // sync content by part id.
            let partContent = contents.getPart(partId)
            let propNames = [
                'entry.deviceName',
                'entry.location',
                'entry.deviceTypeId'
            ]
            assigns(self.content, partContent, ...propNames)
        }

        this.setup = (item) => {
            // set item (1 language)
        }
        this.refresh = () => { updateContents() }
    </script>
</device-entry>