var tabs = {
    selections: {
        tabContainer: '.js-tab-section',
        tabContainerDifficulty: '.js-leaderboard-diff',
        categoryControl:   '.js-tab--cat',
        difficultyControl: '.js-tab--difficulty',
        tabSelectContainer: '.js-leaderboard__cat'
    },

    toggle: function($tab, container) {
        var tabCategory = $tab.data('tab-cat');

        $tab.siblings().removeClass('active');
        $tab.addClass('active');
        $(container).removeClass('active');
        $(tabCategory).addClass('active');
    },

    bind: function() {
        var self = this;

        $(self.selections.tabSelectContainer).on('click', tabs.selections.categoryControl, function(e){
            var $this = $(this);

            $(self.selections.tabSelectContainer).attr('id', 'leaderboard__cat--' + $this.index());
            tabs.toggle($this, tabs.selections.tabContainer);
        });

        $(tabs.selections.difficultyControl).click(function(e) {
            var $this = $(this);

            tabs.toggle($this, tabs.selections.tabContainerDifficulty);
        });
    },

    init: function() {
        tabs.bind();
    }
};
