let app

const eventbus = function() {
    console.log('init event bus.')
    riot.observable(this)
}

riot.tagCount = 0
riot.eventbus = new eventbus()
riot.eventbus.on('all-tags-mounted', () => {
    console.log('all tags mounted')
})
riot.eventbus.on('update-tag-count', () => {
    riot.tagCount++
})
riot.eventbus.on('update-tag-mount', () => {
    riot.tagCount--
    if (riot.tagCount <= 0) {
        riot.eventbus.trigger('all-tags-mounted')
    }
})

;(() => {
    app = riot.mount('rater-web-app')
})()
