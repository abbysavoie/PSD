
html {
    font-family: "Helvetica Neue", Helvetica, Arial, sans-serif;
    -ms-text-size-adjust: 100%;
    -webkit-text-size-adjust: 100%;
	background: white;
}

h1 {
    font-size: 2em;
    margin: 0.67em 0;
}

body {
	margin: 0;
    font-size: 16px;
    font-size: 1em;
    line-height: 1.4;
    background-color: #dde2e5;
    -webkit-font-smoothing: antialiased;
    -moz-osx-font-smoothing: grayscale;
}

::-moz-selection {
    background: #e9e211;
    text-shadow: none;
}

::selection {
    background: #e9e211;
    text-shadow: none;
}

*, *:after, *:before {
    -webkit-box-sizing: border-box;
    -moz-box-sizing: border-box;
    box-sizing: border-box;
    -webkit-font-smoothing: antialiased;
}

img {
    height: auto;
    max-width: 100%;
}

h1, h2, h3, h4, h5, h6, .h1, .h2, .h3, .h4, .h5, .h6 {
    margin: .5em 0;
    color: #37424a;
    font-weight: normal;
    font-family: "Merriweather",serif;
}

h1, h2, h3, h4, .h1, .h2, .h3, .h4 {
    line-height: 1.3;
}

article, aside, details, figcaption, figure, footer, header, hgroup, main, menu, nav, section, summary {
    display: block;
}

h1, .h1 {
    font-size: 36px;
    font-size: 2.25rem;
}

h2, .h2 {
    font-size: 27px;
    font-size: 1.6875rem;
}

h3, .h3 {
    font-size: 24px;
    font-size: 1.5rem;
}

header {
    background: white;
    z-index: 20;
}

header nav {
	line-height: 2;
}

header nav ul {
	margin: 0;
	padding: 0;
	list-style-type: none;
}

header nav a {
	font-weight: 800;
	text-decoration: none;
	text-transform: uppercase;
}

.portal .logo {
    display: block;
    padding: .5em;
    position: relative;
}

.portal .logo img {
	z-index: 2;
	position: relative;
	display: inline-block;
}

.portal .logo:before {
    content: '';
    display: block;
    width: 100%;
    height: 100%;
    position: absolute;
    top: 0em;
    left: 0;
    z-index: 2;
    background: white;
}

@media screen and (min-width: 60em) {
    .portal .logo {
        padding: 0;
    }
	
	.portal header {
		background: #FFC20E;
	}
	
	.portal .logo:before {
		top: -1em;
		height: 180%;
	}

	.portal .logo img {
		top: .5em;
		max-width: 140px;
        max-height: 55px;
	}
	
	.white-popup.slide-pop {
		max-width: 920px;
	}
}

	.top-nav-strip {
		color: white;
		padding: .5em;
		background: #00457C;
	}

    .top-nav-strip p {
        margin: 0;
        line-height: 1.9;
    }

	.top-nav-strip p a {
		color: white;
		text-decoration: none;
	}

	.top-nav-strip p a:hover {
		text-decoration: underline;
	}

    .top-nav-strip .socials a {
        opacity: 0.85;
        color: #005bbb;
        -webkit-transition-property: opacity;
        -moz-transition-property: opacity;
        transition-property: opacity;
        -webkit-transition-duration: .15s;
        -moz-transition-duration: .15s;
        transition-duration: .15s;
    }

	.top-nav-strip .socials a:hover {
		opacity: 1;
	}
		
.l-constrained, .l-constrained--site, .l-constrained--wide, .l-constrained--desktop {
    margin: 0 auto;
    width: 100%;
    max-width: 1200px;
}

@media screen and (min-width: 48em) and (max-width: 59.99em) {
    .portal header {
		background: #FFC20E;
	}
	header > .l-constrained {
        padding-bottom: 2.5em;
    }

	header > .l-constrained .logo--wrap {
		width: 25%;
		float: left;
	}

	header > .l-constrained .three {
		text-align: right;
		width: 25%;
		float: left;
	}

	header > .l-constrained .seven {
		position: static;
		width: 50%;
		float: left;
	}
}

@media screen and (max-width: 47.99em) {
    .portal header {
		background: #FFC20E;
	}
	.portal .menu-toggle {
        top: 3.7em;
    }
	header .logo img {
        max-width: 70px;
    }

    header > .l-constrained {
        padding-bottom: 1em;
    }

	header > .l-constrained .columns {
		width: auto;
		display: inline-block;
	}

	header > .l-constrained .columns.two {
		float: left;
	}
}

	.l-constrained, .l-constrained--site, .l-constrained--wide, .l-constrained--desktop, .l-container, .row, .comment-list article.comment-body footer, .form--newsletter {
		*zoom: 1;
	}

    .l-constrained:before, .l-constrained--site:before, .l-constrained--wide:before, .l-constrained--desktop:before, .l-container:before, .row:before, .comment-list article.comment-body footer:before, .form--newsletter:before, .l-constrained:after, .l-constrained--site:after, .l-constrained--wide:after, .l-constrained--desktop:after, .l-container:after, .row:after, .comment-list article.comment-body footer:after, .form--newsletter:after {
        content: " ";
        display: table;
    }

    .l-constrained:after, .l-constrained--site:after, .l-constrained--wide:after, .l-constrained--desktop:after, .l-container:after, .row:after, .comment-list article.comment-body footer:after, .form--newsletter:after {
        clear: both;
    }
    .library__header > .l-constrained {
        padding: 1em 0;
        background: white;
    }
	
@media screen and (min-width: 60em) {
    header > .l-constrained {
        padding-bottom: 1em;
    }

    header .twelve {
        padding-left: 0;
        padding-right: 0;
    }
	.portal header {
		background: #FFC20E;
	}
}

.row--center .columns {
    margin: 0 auto;
    float: none;
}

.columns {
    min-height: 1px;
}

@media screen and (min-width: 37.5em) and (max-width: 47.99em) {
    .step__single .columns {
        display: inline-block;
    }
	.portal header {
		background: #FFC20E;
	}
}


.quicklinks ul {
    padding: .25em 0 0;
    list-style: none;
}

.quicklinks li {
    margin: 0 .25em;
    display: inline-block;
    font-size: 13px;
    font-size: 0.8125rem;
}

.quicklinks li:after {
	clear: both;
	float: none;
}

.quicklinks li {
    padding: 0 .25em;
    margin: 0;
    height: 28px;
    display: inline;
    font-size: 13px;
    font-size: 0.8125rem;
}

.quicklinks li:last-child:after {
	display: none;
}

.quicklinks a {
    color: white;
    font-weight: 600;
    text-decoration: none;
}

.quicklinks .google-translate {
    display: none;
}

@media screen and (max-width: 47.99em) {
	
	header .logo img {
        max-width: 70px;
    }

    header > .l-constrained {
        padding-bottom: 1em;
    }

	header > .l-constrained .columns {
		width: auto;
		display: inline-block;
	}

	header > .l-constrained .columns.two {
		float: left;
	}
	
    .card--comment .six, .card--comment .form-actions {
        text-align: center;
    }

    .card--comment .card__meta {
        margin-left: 0;
    }

    .card--comment .card__content {
        margin-top: 1em;
    }
	.hide-on-mobile {
        display: none !important;
    }
}

@media screen and (min-width: 48em) {
	   
	.portal header {
		background: #FFC20E;
	}

	.portal .logo {
		text-align: center;
	}
	.top-nav-strip {
		padding: 1em;
		font-size: 13px;
		font-size: 0.8125rem;
	}

	.top-nav-strip .six:last-child {
		text-align: right;
	}
	
	.six {
		width: 50%;
		float: left;
		padding-left: 1.0416588541%;
		padding-right: 1.0416588541%;
	}

	.six.no-gutters {
		padding-left: 0;
		padding-right: 0;
	}
	.event__wrap .six:first-child {
		border-right: 1px solid #dde2e5;
	}
	.columns {
		position: relative;
		float: left;
	}
	.quicklinks .google-translate {
		display: inline-block;
		position: relative;
		padding-top: 5px;
	}

	.quicklinks .google-translate .goog-te-gadget {
		padding-right: 18px;
	}

	.quicklinks .google-translate .goog-te-gadget .goog-te-combo {
		background-color: transparent;
		color: red;
		border: 0;
	}

	.quicklinks .google-translate .goog-te-gadget .goog-te-combo:hover {
		cursor: pointer;
	}

	.quicklinks .google-translate .goog-te-gadget .goog-te-combo:focus {
		outline: 0;
	}

	.quicklinks .google-translate .goog-te-gadget .goog-te-combo option {
		background-color: #0098db;
	}

	.quicklinks .google-translate .goog-logo-link {
		display: none;
	}
	
	.three {
		width: 25%;
		float: left;
		padding-left: 1.0416588541%;
		padding-right: 1.0416588541%;
	}

	.three.no-gutters {
		padding-left: 0;
		padding-right: 0;
	}
	
	.twelve {
		width: 100%;
		float: left;
		/*ivan commented out*/
		/*padding-left: 1.0416588541%;
		padding-right: 1.0416588541%;*/
	}

	.twelve.no-gutters {
		padding-left: 0;
		padding-right: 0;
	}
	
	header {
		position: relative;
		background: #0098db;
	}

	header > .row {
		position: relative;
	}
}

@media screen and (max-width: 74.99em) {
	header > .row {
		padding-left: .5em;
		padding-right: .5em;
	}
}
	
.l-margin-bs {
    margin-bottom: 0.5em;
}	

.l-margin-tn {
    margin-top: 0;
}
	
.quicklinks .google-translate .goog-te-gadget-simple {
   /*Ivan changed background Color*/
    /* background-color: #005bbb; */
     /*background-color: #0098db;*/
	background-color:#00457C;
    border: none;
}

    .quicklinks .google-translate .goog-te-gadget-simple img {
        height: 0px;
        display: none;
    }

    .quicklinks .google-translate .goog-te-gadget-simple .goog-te-menu-value {
        color: #f6f6f6;
        padding: 0 4px;
        margin: 0;
        font-family: "Open Sans",sans-serif;
        font-size: 0.75rem;
    }

	.quicklinks .google-translate .goog-te-gadget-simple .goog-te-menu-value > span + img + span {
		border: none !important;
	}

	.quicklinks .google-translate .goog-te-gadget-simple .goog-te-menu-value > span + img + span + img + span {
		height: 0;
		width: 0;
		right: 8px;
		margin-left: 0;
		margin-top: 0;
		background: none !important;
		border-bottom: 2px solid #f6f6f6 !important;
		border-right: 2px solid #f6f6f6 !important;
		height: 10px;
		height: 0.625rem;
		transform: rotate(45deg);
		width: 10px;
		width: 0.625rem;
		position: absolute;
		top: 9px;
		color: transparent !important;
	}

@media screen and (max-width: 59.99em) {
    header .quicklinks {
        text-align: right;
    }

    header .card--weather {
        margin-top: .5em;
        text-align: center;
    }

        header .card--weather i, header .card--weather p, header .card--weather p.temperature {
            font-size: 16px;
            font-size: 1rem;
        }

        header .card--weather br {
            display: none;
        }
}

.quicklinks ul {
    padding: .25em 0 0;
    list-style: none;
}

.quicklinks li {
    margin: 0 0.25em;
    display: inline-block;
    font-size: 13px;
    font-size: 0.8125rem;
}

.quicklinks li:after {
	color: white;
	content: '|';
	margin-left: .5em;
}

.quicklinks li:last-child:after {
	display: none;
}

.quicklinks a {
    color: white;
    font-weight: 600;
    text-decoration: none;
}

.hero__wrap {
    position: relative;
}

.hero__wrap.hero__wrap--empty {
	min-height: 250px;
	position: absolute;
	width: 100%;
	z-index: 0;
}

.hero__bg {
    background-position: center;
    background-repeat: no-repeat;
    background-size: cover;
}

.hero__bg.hero__bg--secondary {
	position: absolute;
	width: 100%;
	height: 150%;
	max-height: 20em;
	top: 0;
	left: 0;
	z-index: 0;
}

.hero__bg.hero__bg--solid {
	background: #0098db;
	position: absolute;
	width: 100%;
	height: 15em;
	top: 0;
	left: 0;
	z-index: 0;
}

@media screen and (max-width: 74.99em) {
    header > .row {
        padding-left: .5em;
        padding-right: .5em;
    }
}

.l-padding-td {
    padding-top: 1em;
}

.l-padding-bd {
    padding-bottom: 1em;
}

.main__message {
    z-index: 2;
    padding: 1.5em;
    text-align: center;
    position: relative;
    background-color: rgba(0,0,0,0.35);
}

@media screen and (min-width: 20em) {
    .main__message {
        padding: 2.5em 1em;
    }
    /*Ivan added Map Size*/
    #single-map {
        height: 250px;
    }
    #verify-map {
        height: 150px;
    }
}

.main__message .main__heading {
    margin: 0;
    color: white;
    font-size: 48px;
    font-size: 3rem;
}

.main__message .main__content {
    margin: 0;
    color: white;
}

.main__message a {
    color: #fed100;
}

.main__message.main__message--white {
    background-color: white;
}

.main__message.main__message--white a {
	color: #222;
}

.main__message.main__message--white .main__heading {
	color: #222;
}

.main__message.main__message--white .main__content {
	color: #009581;
}

.main__message.main__message--transparent {
    background: transparent;
}

.main__message.main__message--transparent .main__heading {
	color: white;
}
	
.white-popup {
    position: relative;
    background: #fff;
    padding: 20px;
    width: auto;
    /*max-width: 500px;*/
    margin: 20px auto;
}

    .white-popup.slide-pop {
        max-width: 85%;
    }

@media screen and (min-width: 60em) {
    .white-popup.slide-pop {
        max-width: 920px;
    }
}

.l-constrained, .l-constrained--site, .l-constrained--wide, .l-constrained--desktop {
    margin: 0 auto;
    width: 100%;
    max-width: 1200px;
}

.l-constrained--main {
    position: relative;
}

.l-constrained--site {
    max-width: 960px;
}

.l-constrained--wide {
    max-width: 1200px;
}

.l-constrained--desktop {
    max-width: 1500px;
}

.no-gutters {
	padding-left: 0;
	padding-right: 0;
}
h1.start {
	margin: .5em 0;
    color: #FFC20E;
	font-weight: 400;
    font-family: Merriweather,serif;
	line-height: 1.3;
	font-size: 30px;
	font-weight: bold;
}  