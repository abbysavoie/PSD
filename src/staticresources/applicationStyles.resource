 #nextBtn, #submitBtn, #saveBtn,#backBtn {		
	position: relative;
	height: 46px;
	font-size: 16px;
	font-weight: normal;
	margin-left:-10px;
	margin-right:20px;
 }
            
.row {
	padding-right: 20px;
}            
.formheaders {
	margin-left: 16px;
}

.start, .subheading {
	color: #FFC20E;
	/*font-weight: bold;*/
	font-size: 26px;
}            
            
#summaryInstructions {
	color: #00457C;
	font-weight: bold;
	text-align: center;
	font-size:15px;
}

.breadcrumb {    
	padding: 0px;                
    background: transparent;
    list-style: none;
    overflow: hidden;
    margin-top: 20px;
    margin-bottom: 0px;
    margin-left: 0px;
    margin-right: 0px;
    border-radius: 4px;
        
}

.breadcrumb>li {
    display: table-cell;
    vertical-align: top;
    width: 1%;
}

.breadcrumb>li+li:before {
    padding: 0;
}

.breadcrumb li a {
    color:white;
    text-decoration: none;    
    position: relative;
    display: inline-block;
    width: calc( 100% - 10px );
    background-color: hsla(0, 0%, 83%, 1);
    text-align: center;
    text-transform: capitalize;	
    padding: 15px 15px 15px 15px;
    font-size: 20px;    
}

.breadcrumb li.active a {
    background: #00457C;
}

.breadcrumb li.active a:after {
    border-left: 30px solid #00457C;
}

.breadcrumb li:first-child a {
    padding-left: 15px;
}

.breadcrumb li:last-of-type a {
    width: calc( 100% - 38px );
}

.breadcrumb li a:before {
    content: " ";
    display: block;
    width: 0;
    height: 0;
    border-top: 50px solid transparent;
    border-bottom: 50px solid transparent;
    border-left: 30px solid white;
    position: absolute;
    top: 50%;
    margin-top: -50px;
    margin-left: 1px;
    left: 100%;
    z-index: 1;
}
               

.breadcrumb li a:after {
    content: " ";
    display: block;
    width: 0;
    height: 0;
    border-top: 50px solid transparent;
    border-bottom: 50px solid transparent;
    border-left: 30px solid hsla(0, 0%, 83%, 1);
    position: absolute;
    top: 50%;
    margin-top: -50px;
    left: 100%;
    z-index: 2;
}            
            
h1.start {
	margin: .5em 0;
    color: #FFC20E;
	font-weight: 400;
    font-family: Merriweather,serif;
	line-height: 1.3;
	font-size: 36px;
	font-weight: bold;
}            