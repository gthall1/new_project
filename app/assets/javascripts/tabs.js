var tabs = {
    selections: {
        tabContainer: '.js-tab-section',
        tabContainerDifficulty: '.js-leaderboard-diff',
        categoryControl:   '.js-tab--cat',
        difficultyControl: '.js-tab--difficulty'
    },

    toggle: function($tab, container) {
        var tabCategory = $tab.data('tab-cat');

        $tab.siblings().removeClass('active');
        $tab.addClass('active');
        $(container).removeClass('active');
        $(tabCategory).addClass('active');
    },

    bind: function() {
        $(tabs.selections.categoryControl).click(function(e){
            var $this = $(this);

            $('.js-leaderboard__cat').attr('id', 'leaderboard__cat--' + $this.index());
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
