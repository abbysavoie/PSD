	var $j = jQuery.noConflict();
	var securityQuestionandAnswers = new Array();
	
	function registerAccount(){
		$j("#register-modal").removeClass("hidden");
		$j("#login-modal").addClass("hidden");
		$j(".white-popup").css({"max-width":"80%"});
		
	}
        
	function FillUserName(){
		//document.getElementById('usernameResetPassId').value = document.getElementById('usernameId').value;//RHATHI
		//document.getElementById('usernameResetPassId').style.display = 'Block';
		//document.getElementById('usernameResetPassId').style.cssText = "";
		
		//clear the previous answers
		$j("[id*='usernameResetPassId']").val("");
		
		$j("#usernameResetPassId").removeClass("hidden");
		$("#usernameResetPassId").show();
		
		
		$j("[id*='ans1Id']").val("");
		$j("[id*='ans2Id']").val("");
		$j("[id*='ans3Id']").val("");
		
		$j("#QId").addClass("hidden");
		$j("#UId").removeClass("hidden");
		$j("#RId").addClass("hidden");
		$j("#ResetPasswordCancelId").removeClass("hidden");
		$j("#ResetPasswordSubmitId").removeClass("hidden");
		$j("#ResetPasswordNextId").addClass("hidden");
		//$j("#ResetloginButton").addClass("hidden");
	}
	
	function FillEmailAddr(){
	
			$j("#ush1").removeClass("hidden");
			$j("#usb1").removeClass("hidden");

			$j("#ush2").addClass("hidden");
			$j("#usb2").addClass("hidden");

			$j('#ResetusrnameId').removeClass("hidden");
			$j('#cancelbutton').removeClass("hidden");
			
		
	}
                    
	function QuestionandAnswers(){  //Javascript Custom Object
		this.question = null; 
		this.answer = null;
	}
    
    //----For resetting password using security ques-----//
    function ValidateSecurityPass(){
		var answersentered = true;
		var UserQuestionandAnswers = new Array();
		if($j("#ans1Id").val() == ''){
			$j("#ans1Id-error").removeClass("hidden");
			$j("#ans1Id-error").text("Please enter answer the security question.");
			answersentered = false;
			//return false;
		}
		else{
			$j("#ans1Id-error").addClass("hidden");
			var temp = new QuestionandAnswers();
			temp.question = $j("#ques1Id").text();
			temp.answer = $j("#ans1Id").val();
			UserQuestionandAnswers.push(temp);
		}
		if($j("#ans2Id").val() == ''){
			$j("#ans2Id-error").removeClass("hidden");
			$j("#ans2Id-error").text("Please enter answer the security question.");
			answersentered = false;
			//return false;
		}
		else{
			$j("#ans2Id-error").addClass("hidden");
			var temp = new QuestionandAnswers();
			temp.question = $j("#ques2Id").text();
			temp.answer = $j("#ans2Id").val();
			UserQuestionandAnswers.push(temp);
		}
		if($j("#ans3Id").val() == ''){
			$j("#ans3Id-error").removeClass("hidden");
			$j("#ans3Id-error").text("Please enter answer(s) the security question.");
			answersentered = false;
			//return false;
		}
		else{
			$j("#ans3Id-error").addClass("hidden");
			var temp = new QuestionandAnswers();
			temp.question = $j("#ques3Id").text();
			temp.answer = $j("#ans3Id").val();
			UserQuestionandAnswers.push(temp);
		}
		if(answersentered == true){
			var validAns = true;
			console.log(UserQuestionandAnswers);
			for (i = 0; i < securityQuestionandAnswers.length ; i++) {
				for (j = 0; j < UserQuestionandAnswers.length ; j++) {
					if(securityQuestionandAnswers[i].question == UserQuestionandAnswers[j].question){
						console.log(securityQuestionandAnswers[i].question+'-----'+UserQuestionandAnswers[j].question);
						console.log(securityQuestionandAnswers[i].answer+'-----'+UserQuestionandAnswers[j].answer);
						if(securityQuestionandAnswers[i].answer != UserQuestionandAnswers[j].answer){
							if($j("#ques1Id").text() == securityQuestionandAnswers[i].question){
								$j("#ans1Id-error").removeClass("hidden");
								$j("#ans1Id-error").text("Security answer is not valid");
							}
							else if($j("#ques2Id").text() == securityQuestionandAnswers[i].question){
								$j("#ans2Id-error").removeClass("hidden");
								$j("#ans2Id-error").text("Security answer is not valid");
							}
							else if($j("#ques3Id").text() == securityQuestionandAnswers[i].question){
								$j("#ans3Id-error").removeClass("hidden");
								$j("#ans3Id-error").text("Security answer is not valid");
							}
							validAns = false;
						}
						break;
					}
				}
			}
			if(validAns == true){
				//document.getElementById('{!$Component.pgId.fmId.ResetscquesId}').value = document.getElementById('usernameResetPassId').value;
	            var username=$j("#usernameResetPassId").val();
				$j("[id*='ResetscquesId']").val(username);			
				DoResetPasswordusingSecurityQuestions();
			}
			
		}
		else{
			return false;
		}
		 
	}  

    //----Function ends------//	
                    
    $j(document).ready(function(){
		$j("#regAccount").click(function(){
			$j("#login-modal").addClass("hidden");;
			$j("#register-modal").removeClass("hidden");
		});
		
		$j("#CreateAccButton").click(function(){
			//$j("#login-modal").removeClass("hidden");
			//$j("#register-modal").addClass("hidden");
		});
						
    });
                  
    function ValidateLogin(){
		var username = document.getElementById('usernameId').value;
		var password = document.getElementById('passwordId').value;
					
		var usernameId = document.getElementById('usernameId');
		var passwordId = document.getElementById('passwordId');
		
		var usernameEId = document.getElementById('usernameId-error');
		var usernameEVId = document.getElementById('usernameId-error1');
		var passwordEId = document.getElementById('passwordId-error');
					
		if(username == ''){
			//alert('Please enter your username.');
			usernameId.style.cssText = "border: 1px solid red";
			usernameEId.style.cssText = "display:block";
			return false;
		}
		else{
			usernameEId.style.cssText = "display:none";
			
			if(!validateEmail(username)){
				//alert('Your username must be in the form of an email address.');
				usernameEVId.style.cssText = "display:block";
				return false;
			}
			else{
				usernameId.style.cssText = "";
				usernameEVId.style.cssText = "display:none";
				
				if(password == ''){
					//alert('Please enter your password.');
					passwordId.style.cssText = "border: 1px solid red";
					passwordEId.style.cssText = "display:block";
					return false;
				}
				else{
					passwordId.style.cssText = "";
					passwordEId.style.cssText = "display:none";
								
					//document.getElementById('{!$Component.pgId.fmId.LurnmId}').value = username;
					$j("[id*='LurnmId']").val(username);
					console.log('UName'+$j("[id*='LurnmId']").val());
					//document.getElementById('{!$Component.pgId.fmId.LpassId}').value = password;
					$j("[id*='LpassId']").val(password);
					DoLogin();
				}
			}
		}
    }
                    
    function ValidateRegistration(){
           
		//homelss_check();
		//var RegAppname=document.getElementById('HRAPPnmId').value;
		var Fname = document.getElementById('HRFnmId').value;
		var Uname = document.getElementById('HRusrnameId').value;
		var Lname = document.getElementById('HRLnmId').value;
		var SSNname = document.getElementById('HRssnId').value;
		var Phone = document.getElementById('HRphoneId').value;
		var Email = document.getElementById('HRemailId').value;
		var Gender = document.getElementById('HRgenderId');
		var Month = document.getElementById('HRmonthId');
		var Date = document.getElementById('dateday');
		var Year = document.getElementById('dateYear');
		var Age = document.getElementById('HRageId');
		var Password = document.getElementById('HRpassId').value;
		var Repassword = document.getElementById('HRpassRId').value;
		var Street = document.getElementById('HRStreetId').value;
		var City = document.getElementById('HRCityId').value;
		var State = document.getElementById('HRStateId').value;
		var Zipcode = document.getElementById('HRZipcodeId').value;
		var AltStreet = document.getElementById('HRAltStreetId').value;
		var AltCity = document.getElementById('HRAltCityId').value;
		var AltState = document.getElementById('HRAltStateId').value;
		var AltZipcode = document.getElementById('HRAltZipcodeId').value;
		var Scques1 = document.getElementById('HRscques1Id').value;
		var Scans1 = document.getElementById('HRscans1Id').value;
		var Scques2 = document.getElementById('HRscques2Id').value;
		var Scans2 = document.getElementById('HRscans2Id').value;
		var Scques3 = document.getElementById('HRscques3Id').value;
		var Scans3 = document.getElementById('HRscans3Id').value;
		var homeless= document.getElementById('Homeless').value;
		var donotknow= document.getElementById('donotKnow').value;
		                        
        //var AppnameId = document.getElementById('HRAPPnmId');
		var FnameId = document.getElementById('HRFnmId');
		var UnameId = document.getElementById('HRusrnameId');
		var LnameId = document.getElementById('HRLnmId');
		var SSNnameId = document.getElementById('HRssnId');
		var PhoneId = document.getElementById('HRphoneId');
		var EmailId = document.getElementById('HRemailId');
		var GenderId = document.getElementById('HRgenderId');
		var AgeId = document.getElementById('HRageId');
		var MonthId = document.getElementById('HRmonthId');
		var DateId = document.getElementById('dateday');
		var YearId = document.getElementById('dateYear');
		var PasswordId = document.getElementById('HRpassId');
		var RepasswordId = document.getElementById('HRpassRId');
		var StreetId = document.getElementById('HRStreetId');
		var CityId = document.getElementById('HRCityId');
		var StateId = document.getElementById('HRStateId');
		var ZipcodeId = document.getElementById('HRZipcodeId');
		var AltStreetId = document.getElementById('HRAltStreetId');
		var AltCityId = document.getElementById('HRAltCityId');
		var AltStateId = document.getElementById('HRAltStateId');
		var AltZipcodeId = document.getElementById('HRAltZipcodeId');
		var Scques1Id = document.getElementById('HRscques1Id');
		var Scans1Id = document.getElementById('HRscans1Id');
		var Scques2Id = document.getElementById('HRscques2Id');
		var Scans2Id = document.getElementById('HRscans2Id');
		var Scques3Id = document.getElementById('HRscques3Id');
		var Scans3Id = document.getElementById('HRscans3Id');
		var homelessId = document.getElementById('Homeless');
		var donotknowId = document.getElementById('donotKnow');
        // alert(SSNname);
                        
		//var AppnameEId = document.getElementById('HRAPPnmId-error');
		var FnameEId = document.getElementById('HRFnmId-error');
		var UnameEId = document.getElementById('HRuserNameId1-error');
		var UnameEId2 = document.getElementById('HRuserNameId2-error');
		var LnameEId = document.getElementById('HRLnmId-error');
		var LnameEId_1 = document.getElementById('HRLnmId_1-error');
		var GenderEId = document.getElementById('HRgenderId-error');
		var MonthEId = document.getElementById('HRmonthId-error');
		var DateEId = document.getElementById('HRdateId-error');
		var YearEId = document.getElementById('HRyearId-error');
		var Scques1EId = document.getElementById('HRscques1Id-error');
		var Scques2EId = document.getElementById('HRscques2Id-error');
		var Scques3EId = document.getElementById('HRscques3Id-error');
		var Scans1EId = document.getElementById('HRscans1Id-error');
		var Scans2EId = document.getElementById('HRscans2Id-error');
		var Scans3EId = document.getElementById('HRscans3Id-error');
		var SSNnameEId = document.getElementById('HRssnId-error');

                  
		var PasswordEId = document.getElementById('HRpassId-error');
		var PasswordE1Id = document.getElementById('HRpassId-error1');
	  //var PasswordE2Id = document.getElementById('HRpassId-error2'); 
		var RepasswordEId = document.getElementById('HRpassRId-error');
		var RepasswordEVId = document.getElementById('HRpassRId-error1');
                        
        /*if(RegAppname == ''){
		    //alert('Please enter your first name.');
		    AppnameId.style.cssText = "border: 1px solid red";
		    AppnameEId.style.cssText = "display:block";
		    return false;
        }
        else{
            AppnameId.style.cssText = "";
            AppnameEId.style.cssText = "display:none";*/
				
				if(Uname == ''){
					//alert('Please enter a username name.');
					UnameId.style.cssText = "border: 1px solid red";
					UnameEId.style.cssText = "display:block";
					document.getElementById('HRusrnameId').focus();
					return false;
					}
					else{
						UnameId.style.cssText = "";
						UnameEId.style.cssText = "display:none";
						
				if(!validateEmail(Uname)){
				//alert('Your username must be in the form of an email address.');
				UnameId.style.cssText = "border: 1px solid red";
				UnameEId2.style.cssText = "display:block";
				document.getElementById('HRusrnameId').focus();
				return false;
				}
				else{
					UnameId.style.cssText = "";
					UnameEId2.style.cssText = "display:none";
				
				if(Fname == ''){
					// alert('Please enter your first name.');
					FnameId.style.cssText = "border: 1px solid red";
					FnameEId.style.cssText = "display:block";
					document.getElementById('HRFnmId').focus();
					return false;
                }
                else{
					FnameId.style.cssText = "";
					FnameEId.style.cssText = "display:none";
					        
					if(Lname == ''){
						//alert('Please enter your last name.');
						LnameId.style.cssText = "border: 1px solid red";
						LnameEId.style.cssText = "display:block";
						document.getElementById('HRLnmId').focus();
						return false;
                    }
				    else{
				    	//RHATHI 07/07/17 last name limit
				    	var minLnameChar = 2;
				        if(Lname.length < minLnameChar) {
				        	LnameId.style.cssText = "border: 1px solid red";
							LnameEId_1.style.cssText = "display:block";
							document.getElementById('HRLnmId').focus();
							return false;
    					}
				    
					    LnameId.style.cssText = "";
					    LnameEId.style.cssText = "display:none";
					    LnameEId_1.style.cssText = "display:none";
                                        
					    var Scques1Value = $j( "#HRscques1Id" ).val();
					    //alert(Scques1Value);
					    if(Scques1Value == 'Select your security question'){
					        //alert('Please select your gender.');
					        Scques1Id.style.cssText = "border: 1px solid red";
					        Scques1EId.style.cssText = "display:block";
							document.getElementById('HRscques1Id').focus();
					        return false;
                        }
                        else{
							Scques1Id.style.cssText = "";
							Scques1EId.style.cssText = "display:none";
                                        
							var Scans1Value = $j( "#HRscans1Id" ).val();
							if(Scans1Value == ''){
							    //alert('Please enter your answer for security question.');
							    Scans1Id.style.cssText = "border: 1px solid red";
							    Scans1EId.style.cssText = "display:block";
								document.getElementById('HRscans1Id').focus();
							    return false;
                            }
                            else{
								Scans1Id.style.cssText = "";
								Scans1EId.style.cssText = "display:none";
                                        
								var Scques2Value = $j( "#HRscques2Id" ).val();
								//alert(Scques2Value);
								if(Scques2Value == 'Select your security question'||Scques2Value==Scques1Value){
								    //alert('Please select your second and different security question');
								    Scques2Id.style.cssText = "border: 1px solid red";
								    Scques2EId.style.cssText = "display:block";
									document.getElementById('HRscques2Id').focus();
								    return false;
                                }
                                else{
									Scques2Id.style.cssText = "";
									Scques2EId.style.cssText = "display:none";
                                        
									var Scans2Value = $j( "#HRscans2Id" ).val();
									if(Scans2Value == ''){
				                        //alert('Please enter your answer for security question.');
									    Scans2Id.style.cssText = "border: 1px solid red";
									    Scans2EId.style.cssText = "display:block";
										document.getElementById('HRscans2Id').focus();
									    return false;
                                    }
                                    else{
                                        Scans2Id.style.cssText = "";
                                        Scans2EId.style.cssText = "display:none";
                                        
                                        var Scques3Value = $j( "#HRscques3Id" ).val();
                                        //alert(Scques3Value);
                                        if(Scques3Value == 'Select your security question'||Scques3Value==Scques1Value||Scques3Value==Scques2Value){
                                            //alert('Please select your third and different security question.');
                                            Scques3Id.style.cssText = "border: 1px solid red";
                                            Scques3EId.style.cssText = "display:block";
											document.getElementById('HRscques3Id').focus();
                                            return false;
                                        }
                                        else{
                                            Scques3Id.style.cssText = "";
                                            Scques3EId.style.cssText = "display:none";
                                        
                                            var Scans3Value = $j( "#HRscans3Id" ).val();
                                            if(Scans3Value == ''){
                                                //alert('Please enter your answer for security question.');
                                                Scans3Id.style.cssText = "border: 1px solid red";
                                                Scans3EId.style.cssText = "display:block";
												document.getElementById('HRscans3Id').focus();
                                                return false;
                                            }
                                            else{
                                                Scans3Id.style.cssText = "";
                                                Scans3EId.style.cssText = "display:none";
                                            
                                          


                                                   
                                                var checkboxvalue=document.getElementById('donotKnow').checked; //Narasimha 30/6/2017
                                                var SSNValue = $j( "#HRssnId" ).val();
                                                //alert(SSNValue); 
                                                if(SSNValue == '' && !checkboxvalue){  //Narasimha END 30/6/2017

						
                                                    //alert('Please enter your SSN');
                                                    SSNnameId.style.cssText = "border: 1px solid red";
                                                    SSNnameEId.style.cssText = "display:block";
													document.getElementById('HRssnId').focus();
                                                    return false;
                                                }
                                                else{
                                                     var x = $j("#HRssnId").val();
                                                    //var checkeds=$(donotKnow).is(':checked');
                                                      var checkeds= document.getElementById('donotKnow').checked;
                                            
                                                    //alert(checkeds);
                                                     //alert(x.size());
                                                     if(x.length<11 && checkeds==false )
                                                        {

                                                   //alert('Please Enter SSN in the Format xxx-xx-xxxx ');
                                                  SSNnameId.style.cssText = "border: 1px solid red";
						   SSNnameEId.style.cssText = "display:block";
 
						  document.getElementById('HRssnId').focus();
                                                    return false;
                                                           }
                                                 

                                                    SSNnameId.style.cssText = "";
                                                   SSNnameEId.style.cssText = "display:none";
                                        
                                                    var GenderValue = $j( "#HRgenderId" ).val();
                                                    //alert(GenderValue);
													if(GenderValue == 'None'){
														//alert('Please select your gender.');
													    GenderId.style.cssText = "border: 1px solid red";
													    GenderEId.style.cssText = "display:block";
														document.getElementById('HRgenderId').focus();
													    return false;
                                                    }
                                                    else{
														GenderId.style.cssText = "";
													    GenderEId.style.cssText = "display:none";
														
														var MonthValue = $j( "#HRmonthId" ).val();
														//alert(MonthValue);
														if(MonthValue == 0){
															//alert('Please select your gender.');
															MonthId.style.cssText = "border: 1px solid red";
															MonthEId.style.cssText = "display:block";
															document.getElementById('HRmonthId').focus();
															return false;
														}
														else{
															MonthId.style.cssText = "";
															MonthEId.style.cssText = "display:none";
															
															var DateValue = $j( "#dateday" ).val();
															//alert(DateValue);
															if(DateValue == 0){
																	//alert('Please select your gender.');
																	DateId.style.cssText = "border: 1px solid red";
																	DateEId.style.cssText = "display:block";
																	document.getElementById('dateday').focus();
																	return false;
															}
															else{
																DateId.style.cssText = "";
																DateEId.style.cssText = "display:none";
																
																var YearValue = $j( "#dateYear" ).val();
																//alert(YearValue);
																if(YearValue == 0){
																	//alert(YearValue);
																	YearId.style.cssText = "border: 1px solid red";
																	YearEId.style.cssText = "display:block";
																	document.getElementById('dateYear').focus();
																	return false;
																}
																else{
																	YearId.style.cssText = "";
																	YearEId.style.cssText = "display:none";
															
																	if(Password == ''){
																		//alert('Please enter your password.');			
																		PasswordId.style.cssText = "border: 1px solid red";
																		PasswordEId.style.cssText = "display:block";
																		document.getElementById('HRpassId').focus();
																		return false;
																	}
																	else{
																		PasswordEId.style.cssText = "display:none";
														
																		if(Password.length < 10){
																			//alert('Password length should be greater than 8.');
																			PasswordId.style.cssText = "border: 1px solid red";    
																			PasswordE1Id.style.cssText = "display:block";
																			document.getElementById('HRpassId').focus();
																			// PasswordE2Id.style.cssText = "display:none";
																			return false;
																		}
																		else{
																			PasswordId.style.cssText = "";
																			PasswordE1Id.style.cssText = "display:none";
																			//PasswordE2Id.style.cssText = "display:block";
															
																			if(Repassword == ''){
																			//alert('Please enter your re-type password.');
																			RepasswordId.style.cssText = "border: 1px solid red";
																			RepasswordEId.style.cssText = "display:block";
																			document.getElementById('HRpassRId').focus();
																			return false;
																		}
																		else{
																			RepasswordEId.style.cssText = "display:none";
																
																			if(Password != Repassword){
																				//alert('Password and Re-Type Password do not match.');
																				RepasswordEVId.style.cssText = "display:block";
																				return false;
																			}
																			else{
																				RepasswordId.style.cssText = "";
																				RepasswordEVId.style.cssText = "display:none";
																				$j("[id*='RusrnameId']").val(Uname);
																				//document.getElementById('{!$Component.pgId.fmId.RFnmId}').value = Fname;
																				$j("[id*='RFnmId']").val(Fname);
																				//document.getElementById('{!$Component.pgId.fmId.RLnmId}').value = Lname;
																				$j("[id*='RLnmId']").val(Lname);
																				//document.getElementById('{!$Component.pgId.fmId.RAPPnmId}').value = RegAppname;
																				//$j("[id*='RAPPnmId']").val(RegAppname);
																				//document.getElementById('{!$Component.pgId.fmId.RssnId}').value = SSNname;
																				$j("[id*='RssnId']").val(SSNname);
																				//document.getElementById('{!$Component.pgId.fmId.RphoneId}').value = Phone;
																				$j("[id*='RphoneId']").val(Phone);
																				//document.getElementById('{!$Component.pgId.fmId.RemailId}').value = Email;
																				$j("[id*='RemailId']").val(Email);
																				//document.getElementById('{!$Component.pgId.fmId.RgenderId}').value = $j( "#HRgenderId" ).val();
																				$j("[id*='RgenderId']").val($j( "#HRgenderId" ).val());
																				//document.getElementById('{!$Component.pgId.fmId.RmonthId}').value = Month;
																				//document.getElementById('{!$Component.pgId.fmId.RageId}').value =Age;
																				//document.getElementById('{!$Component.pgId.fmId.RpassId}').value = Password;
																				$j("[id*='RpassId']").val(Password);
																				//document.getElementById('{!$Component.pgId.fmId.RpassRId}').value = Repassword;
																				$j("[id*='RpassRId']").val(Repassword);
																				//document.getElementById('{!$Component.pgId.fmId.RStreetId}').value = Street;
																				$j("[id*='RStreetId']").val(Street);
																				//document.getElementById('{!$Component.pgId.fmId.RCityId}').value = City;
																				$j("[id*='RCityId']").val(City);
																				//document.getElementById('{!$Component.pgId.fmId.RStateId}').value = State;
																				$j("[id*='RStateId']").val(State);
																				//document.getElementById('{!$Component.pgId.fmId.RZipcodeId}').value = Zipcode;
																				$j("[id*='RZipcodeId']").val(Zipcode);
																				//document.getElementById('{!$Component.pgId.fmId.RAltStreetId}').value = AltStreet;
																				$j("[id*='RAltStreetId']").val(AltStreet);
																				//document.getElementById('{!$Component.pgId.fmId.RAltCityId}').value = AltCity;
																				$j("[id*='RAltCityId']").val(AltCity);
																				//document.getElementById('{!$Component.pgId.fmId.RAltStateId}').value = AltState;
																				$j("[id*='RAltStateId']").val(AltState);
																				//document.getElementById('{!$Component.pgId.fmId.RAltZipcodeId}').value = AltZipcode;
																				$j("[id*='RAltZipcodeId']").val(AltZipcode);
																				//document.getElementById('{!$Component.pgId.fmId.RscquesId}').value = Scques[Scques.selectedIndex].text;
																				//document.getElementById('{!$Component.pgId.fmId.Rscques1Id}').value = $j( "#HRscques1Id option:selected" ).val();
																				$j("[id*='Rscques1Id']").val($j( "#HRscques1Id option:selected" ).val());
																				//document.getElementById('{!$Component.pgId.fmId.Rscans1Id}').value = Scans1;
																				$j("[id*='Rscans1Id']").val(Scans1);
																				//document.getElementById('{!$Component.pgId.fmId.Rscques2Id}').value = $j( "#HRscques2Id option:selected" ).val();
																				$j("[id*='Rscques2Id']").val($j( "#HRscques2Id option:selected" ).val());
																				//document.getElementById('{!$Component.pgId.fmId.Rscans2Id}').value = Scans2;
																				$j("[id*='Rscans2Id']").val(Scans2);
																				//document.getElementById('{!$Component.pgId.fmId.Rscques3Id}').value = $j( "#HRscques3Id option:selected" ).val();
																				$j("[id*='Rscques3Id']").val($j( "#HRscques3Id option:selected" ).val());
																				//document.getElementById('{!$Component.pgId.fmId.Rscans3Id}').value = Scans3;
																				$j("[id*='Rscans3Id']").val(Scans3);
																				//alert(Gender[Gender.selectedIndex].text);
																				$j("[id*='Homeless_check_Id']").val($j('#Homeless').prop('checked'));
																				$j("[id*='SSN_DoNotHave_Id']").val($j('#donotKnow').prop('checked'));
																				$j("[id*='paperless_Id']").val($j('#showPaperless').prop('checked'));		
																				homelss_check();
																				console.log('the function passes---->'+ homelss_check());
																				if(homelss_check()==true){  
																				registerAccounttoSFDCinJS();
																				}
																				//alert('Account has been successfully created');
																			}
																		}
																	}
																}
															}
														}
                                                    }
                                                }
                                            }  
                                        }
                                    }                       
                                }
                            }
                        }
                    }
                }
				}
			}
        }
    }
    
	//For resetting password using email------//
    
    function ValidateForgetPassword(){
    	    var username = document.getElementById('usernameResetPassId').value
    	    if(username == ''){
    		    //alert('Please enter your username.');
    		    $j("#usernameResetPassId").css({"border":"1px solid red","display":"block"});
    		    $j("#usernameResetPassId-error").removeClass("hidden");
    		    $j("#usernameResetPassId-error").text("User Name is Required");
                        return false;
            }
            else{
    		//document.getElementById('{!$Component.pgId.fmId.ReseturId}').value = username;
    		$j("[id*='ReseturId']").val(username);
    	    	//document.getElementById('PassResetMsgId').style.display = 'Block';
    	    	$j("#mhdr1").addClass("hidden");
    	    	$j("#UId").addClass("hidden");
    	    	
    	    	$j("#mhdr2").removeClass("hidden");
    	    	$j("#RId").removeClass("hidden");
    	    	//document.getElementById('PassResetId').style.display = 'None';
    		DoResetPassword();
    		//alert('hello 123');
    		    
            }
    } 
    // Function end
    
    //---Function for resetting username---//
    function Validateusername(){
        var username = document.getElementById('frgtusrnmId').value
        if(username == ''){
			
           $j("#frgtusrnmId").css({"border":"1px solid red","display":"block"});
			$j("#frgtusrnmId").addClass("input-error");
			$j("#frgtusrnmId-error").removeClass("hidden");
			$j("#frgtusrnmId-error").text("Please enter a valid Email");
            return false;
           

        }
        else{	
            	
		$j("#ush1").addClass("hidden");
		$j("#usb1").addClass("hidden");

		$j("#ush2").removeClass("hidden");
		$j("#usb2").removeClass("hidden");
		
		$j('#ResetusrnameId').addClass("hidden");
		
		$j("[id*='ResetusernameId']").val(username);
		sendusername();
		
		//alert('hello 123');

        }
    }
	/*----Function ends--------*/
		
	/*-------function for ssn search-----*/
	
	function validateSSNsearch(){
		var searchforssn = document.getElementById('ssn_ID').value;
		var lnameforssn  = document.getElementById('ssnLName_ID').value;
		$j("#ssnsearch-error").addClass("hidden");
		$j("#ssnlname-error").addClass("hidden");
		
		if(searchforssn == '' || lnameforssn == ''){

		   if(searchforssn == ''){					
			$j("#ssn_ID").css({"border":"1px solid red","display":"block"});
			$j("#ssn_ID").addClass("input-error");
			$j("#ssnsearch-error").removeClass("hidden");
			$j("#ssnsearch-error").text("Please enter a valid SSN");
		   }
		   if(lnameforssn == ''){
			$j("#ssnLName_ID").css({"border":"1px solid red","display":"block"});
			$j("#ssnLName_ID").addClass("input-error");
			$j("#ssnlname-error").removeClass("hidden");
			$j("#ssnlname-error").text("Please enter a valid Lastname");
		   }
		   return false;
		}
		else{	

			$j("[id*='ResetSSNsearchId']").val(searchforssn);
			$j("[id*='ResetSSNLnameId']").val(lnameforssn);
			searchSSN();
		}
    }
                            
    //----Function ends-----//
                    
	function googleTranslateElementInit(){
		new google.translate.TranslateElement({pageLanguage: 'en', includedLanguages: 'en,es,vi', layout: google.translate.TranslateElement.InlineLayout.SIMPLE}, 'google_translate_element');
		changeLanguageText();
	}
                    
	
	function changeLanguageText(){
		var el = jQuery('.goog-te-menu-value span:first-child');
		if (el.text() == 'Select Language'){ 
		    jQuery(el).html('English');
			jQuery('#google_translate_element').fadeIn('slow');
		} 
		else{
	        setTimeout(changeLanguageText, 10);
		}
	}
	
	
	$j(document).ready(function() {
		$j('#showPaperless').change(function() {
			if ($(this).prop('checked')) {
				//alert("You have choosen not to receive any paper mails"); //checked
			}
			else{
				//alert("You have choosen to receive paper mails"); //not checked
			}
		});
	});
                    
	
	function validateEmail(email){
		var re = /^(([^<>()\[\]\\.,;:\s@"]+(\.[^<>()\[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;
		return re.test(email);
	}
                                  
    function myFunc(){
        var patt = /^[1-9]\d{3}[-]\d{2}[-]\d{4}$/g;
	    var x = $j("#HRssnId").val();
	    //alert(x);
	    //var res = patt.test(x);
	    //alert(res);
                    

        if(x.length <=12){
			//alert('PLEASE ENTER SSN in the format xxx-xx-xxxx ');
			x = x.match(/\d*/g).join('').match(/(\d{0,3})(\d{0,2})(\d{0,4})/).slice(1).join('-').replace(/-*$/g, '');
			//alert(x);
			$j("#HRssnId").val(x);
        }
        else {
		}
    }
	
	function SsnSearch(){
        var patt = /^[1-9]\d{3}[-]\d{2}[-]\d{4}$/g;
	    var x = $j("#ssn_ID").val();
	    //alert(x);
	    //var res = patt.test(x);
	    //alert(res);
        if(x.length <= 12){
			//alert('PLEASE ENTER SSN in the format xxx-xx-xxxx ');
			x = x.match(/\d*/g).join('').match(/(\d{0,3})(\d{0,2})(\d{0,4})/).slice(1).join('-').replace(/-*$/g, '');
			//alert(x);
			$j("#ssn_ID").val(x);
        }
        else {
		}
    }
	
	
	function donotHaveSSN(){
		if($j("#donotKnow").is(":checked")){
			
			$j('#HRssnId').val(""); // Narashimha  30/06/2017 
			
			$j("#HRssnId").prop('disabled', true);
		}
		else{
			$j("#HRssnId").prop('disabled', false);
		}
	}
	
	function homeless_yes(){
		if($j("#Homeless").is(":checked")){
			
			$j("#HRStreetId").prop('disabled', false);
			$j("#HRCityId").prop('disabled', false);
			$j("#HRStateId").prop('disabled', false);
			$j("#HRZipcodeId").prop('disabled', false);
			
		}
		else{
			$('#HRStreetId').val("");
			$j("#HRStreetId").prop('disabled', true);
			
			$('#HRCityId').val("");
			$j("#HRCityId").prop('disabled', true);
			
			$('#HRStateId').val("");
			$j("#HRStateId").prop('disabled', true);
			
			$('#HRZipcodeId').val("");
			$j("#HRZipcodeId").prop('disabled', true);
			
		}
	}
	
    function myphFunc(){
        var patt = /^[1-9]\d{3}[-]\d{3}[-]\d{4}$/g;
	    var x = $j("#HRphoneId").val();
	    //alert(x);
	    //var res = patt.test(x);
	    //alert(res);
	    if(x.length <= 11){
		   //alert('PLEASE ENTER SSN in the format xxx-xx-xxxx ');
		   x = x.match(/\d*/g).join('').match(/(\d{0,3})(\d{0,3})(\d{0,4})/).slice(1).join('-').replace(/-*$/g, '');
		   //alert(x);
		   $j("#HRphoneId").val(x);
	    }
    }
	
	
    
	/*function fillAddress(){
        //alert($j("#Homeless").is(":checked"));
		if( $j("#Homeless").is(":checked")){
			$j("#HRStreetId").val('1122 Broadway St');
			$j("#HRCityId").val('San Diego');
			$j("#HRStateId").val('California');
			$j("#HRZipcodeId").val('92101');
			$j("#HRStreetId").prop('disabled', true);
			$j("#HRCityId").prop('disabled', true);
			$j("#HRStateId").prop('disabled', true);
			$j("#HRZipcodeId").prop('disabled', true);
        }
        else{
			$j("#HRStreetId").val('');
			$j("#HRCityId").val('');
			$j("#HRStateId").val('');
			$j("#HRZipcodeId").val('');
			$j("#HRStreetId").prop('disabled', false);
			$j("#HRCityId").prop('disabled', false);
			$j("#HRStateId").prop('disabled', false);
			$j("#HRZipcodeId").prop('disabled', false);
        }
    } 


	
	
/*function ResetPasswordusingSecurityQuestions(){
var username = document.getElementById('usernameResetPassId').value
if(username == ''){
   alert('Please enter your username.');
   return false;
}
else{
	  document.getElementById('{!$Component.pgId.fmId.ResetscquesId}').value = username;
	  DoResetPasswordusingSecurityQuestions();
}
		
}*/