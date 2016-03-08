var tabs = {
    selections: {
        tabContainer: '.js-tab-section',
        tabContainerDifficulty: '.js-leaderboard-diff',
        categoryControl:   '.js-tab--cat',
        difficultyControl: '.js-tab--difficulty',
        tabSelectContainer: '.js-leaderboard__cat'
    },

    toggle: function($tab, container) {
        var tabCategory = $tab.data('tab-cat'),
            toCurrentUser = window.location.origin + window.location.pathname + '#leaderboard-row--current-user';

        $tab.siblings().removeClass('active');
        $tab.addClass('active');
        $(container).removeClass('active');
        $(tabCategory).addClass('active');

        if ($('body').hasClass('leaderboard-page--mobile')) {
            window.location.href = toCurrentUser;
        }
    },

    bind: function() {
        var self = this;

        $(self.selections.tabSelectContainer).on('click', tabs.selections.categoryControl, function(e){
            var $this = $(this);
            // debugger;
            $(self.selections.tabSelectContainer).attr('id', 'leaderboard__cat--' + $this.index());
            tabs.toggle($this, tabs.selections.tabContainer);
        });

        $(tabs.selections.difficultyControl).on('click', function(e) {
            var $this = $(this);

            tabs.toggle($this, tabs.selections.tabContainerDifficulty);
        });
    },

    init: function() {
        tabs.bind();
    }
};
