<device-entry>
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
        let clearInputs = () => {
            location.clear()
            // required to check null in case some input(s) not used in
            // multilanguages tab
            if (deviceTypes) deviceTypes.clear()
            deviceName.clear()
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

        let origObj
        let editObj
        let ctrlToObj = () => {
            if (editObj) {
                //console.log('ctrlToObj:', editObj)
                if (deviceName) editObj.DeviceName = deviceName.value()
                if (location) editObj.Location = location.value()
                if (deviceTypes) editObj.deviceTypeId = deviceTypes.value()
            }
        }
        let objToCtrl = () => {
            if (editObj) {
                //console.log('objToCtrl:', editObj)
                if (deviceName) deviceName.value(editObj.DeviceName)
                if (location) location.value(editObj.Location)
                if (deviceTypes && editObj.deviceTypeId) {
                    deviceTypes.value(editObj.deviceTypeId.toString())
                }
            }
        }
        this.setup = (item, lookup) => {
            clearInputs()
            // set lookup.
            if (deviceTypes) {
                deviceTypes.setup(lookup.devicetypes, { valueField:'deviceTypeId', textField:'Type' })
            }

            origObj = clone(item)
            editObj = clone(item)
            //console.log('edit obj:', editObj)
            objToCtrl()
        }
        this.getItem = () => {
            ctrlToObj()
            //console.log('getItem:', editObj)
            let hasId = (editObj.deviceId !== undefined && editObj.deviceId != null)
            let isDirty = !hasId || !equals(origObj, editObj)
            //console.log(editObj)
            return (isDirty) ? editObj : null
        }
        this.refresh = () => { updateContents() }
    </script>
</device-entry>