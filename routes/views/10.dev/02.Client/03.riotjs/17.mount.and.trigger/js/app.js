let app

const eventbus = function() {
    //console.log('init event bus.')
    riot.observable(this)
}
riot.tagCount = 0
riot.eventbus = new eventbus()
riot.eventbus.on('all-tags-mounted', () => { console.log('all tags mounted') })
riot.hook = (tag) => {
    tag.on('before-mount', () => { riot.tagCount++ })
    tag.on('mount', () => {
        riot.tagCount--
        if (riot.tagCount <= 0) {
            riot.eventbus.trigger('all-tags-mounted')
        }
        })
    tag.on('unmount', () => {})
}

;(() => {
    app = riot.mount('rater-web-app')
})()
