package MT::Plugin::SlideToggle;
use strict;
use warnings;
use base 'MT::Plugin';

our $VER  = '0.01';
our $NAME = ( split /::/, __PACKAGE__ )[-1];

my $plugin = __PACKAGE__->new({
    name    => $NAME,
    id      => lc $NAME,
    key     => lc $NAME,
    version => $VER,
    author_name => 'masiuchi',
    author_link => 'https://github.com/masiuchi/',
    plugin_link => 'https://github.com/masiuchi/mt-plugin-slide-toggle/',
    description => '<__trans phrase="Try to use slideToggle method of jQuery.">',
    registry => {
        callbacks => {
            'MT::App::CMS::template_source.header'      => \&_tmpl_src_header,
            'MT::App::CMS::template_source.footer'      => \&_tmpl_src_footer,
            'MT::App::CMS::template_source.list_common' => \&_tmpl_src_list_common,
        },
    },
});
MT->add_plugin( $plugin );

sub _tmpl_src_header {
    my ( $cb, $app, $tmpl_ref) = @_;

    my $old = quotemeta( <<'HTMLHEREDOC' );
</head>
HTMLHEREDOC

    my $new = <<'HTMLHEREDOC';
<script style="text/javascript">
<!--
    jQuery.mtMenu = function(options) {
        var defaults = {
            arrow_image: StaticURI+'images/arrow/arrow-toggle-big.png'
        };
        var opts = jQuery.extend(defaults, options);
        jQuery('.top-menu > div a').after('<a href="#" class="toggle-button"><img src="'+opts.arrow_image+'" /></a>');
        jQuery('.top-menu .toggle-button')
            .mousedown(function(event) {
                jQuery(this).parents('li.top-menu').toggleClass('top-menu-open active');
                jQuery(this).parents('li.top-menu').find('.sub-menu').slideToggle('fast');
                return false;        })
            .click(function(event) {
                return false;
            });
    };

    jQuery.mtSelector = function(options) {
        var defaults = {
            arrow_image: StaticURI+'images/arrow/arrow-toggle.png'
        };
        var opts = jQuery.extend(defaults, options);
        jQuery('#selector-nav').prepend('<a hre="#" class="toggle-button"><img src="'+opts.arrow_image+'" /></a>');

        jQuery('#selector-nav .toggle-button ')
            .mousedown(function(event) {
                var selnav = jQuery(this).parent('#selector-nav');
                selnav.children('#scope-selector').slideToggle('fast');
                selnav.toggleClass('show-selector active');
                return false;
            })
            .click(function(event) {
                return false;
            });
        jQuery(document).mousedown(function(event) {
            if (jQuery(event.target).parents('#selector-nav').length == 0) {
                var selnav = jQuery('#selector-nav');
                selnav.children('#scope-selector').slideUp('fast');
                selnav.removeClass('show-selector active');
            }
        });
        if (!jQuery.support.style && !jQuery.support.objectAll) {
            if (jQuery.fn.bgiframe) jQuery('div.selector').bgiframe();
        }
    };


    jQuery.fn.mtToggleField = function(options) {
        var defaults = {
            click_class: 'detail-link',
            detail_class: 'detail',
            hide_clicked: false,
            default_hide: true
        };
        var opts = jQuery.extend(defaults, options);
        return this.each(function() {
            var $field = jQuery(this);
            if (opts.default_hide)
                $field.find('.'+opts.detail_class).hide();
            $field.find('.'+opts.click_class)
                .mousedown(function(event) {
                    $field.toggleClass('active').find('.'+opts.detail_class).slideToggle('fast');
                    return false;
                })
                .click(function(event) {
                    return false;
                });

            if (opts.hide_clicked) {
                jQuery(document).mousedown(function(event) {
                    if (jQuery(event.target).parents('.active').length == 0) {
                        $field.removeClass('active').find('.'+opts.detail_class).slideUp('fast');
                    }
                });
             }
        });
    };
//-->
</script>
HTMLHEREDOC

    $$tmpl_ref =~ s!($old)!$new$1!;
}

sub _tmpl_src_footer {
    my ( $cb, $app, $tmpl_ref) = @_;

    my $old = quotemeta( <<'HTMLHEREDOC' );
    jQuery('.fav-actions-nav, #cms-search').mtToggleField({hide_clicked: true});
HTMLHEREDOC

    my $new = <<'HTMLHEREDOC';
    jQuery('.fav-actions-nav').mtToggleField({hide_clicked: true});
    jQuery('#quick-search-form').show();
    jQuery('#cms-search').mtToggleField({detail_class: 'basic-search', hide_clicked: true});
HTMLHEREDOC

    $$tmpl_ref =~ s!$old!$new!;
}

sub _tmpl_src_list_common {
    my ( $cb, $app, $tmpl_ref ) = @_;

    my $old = quotemeta( <<'HTMLHEREDOC' );
  jQuery('.indicator, #listing-table-overlay').show();
HTMLHEREDOC

    my $new = <<'HTMLHEREDOC';
  jQuery('tbody').toggle('fast');
HTMLHEREDOC

    $$tmpl_ref =~ s!($old)!$1$new!;

    $old = quotemeta( <<'HTMLHEREDOC' );
      jQuery('.indicator, #listing-table-overlay').hide();
HTMLHEREDOC

    $new = <<'HTMLHEREDOC';
      jQuery('tbody').toggle('fast');
HTMLHEREDOC

    $$tmpl_ref =~ s!($old)!$1$new!;
}

1;
__END__
