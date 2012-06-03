<?php

	/* in IBEAM framework the controller is the .mod file. The view
     * is the .tile file and the models are the .qry file 
     * No sample model file and the tile file has been included as part of the code sample
	 * editjob.mod
	 * this is the controller file 
	 * the view for this file is editjob.tile
	 * the controller uses various model files which have .qry extension
	 * created on $Date: Monday, January 17, 2007
	 * 
	 */
	 require_once(IBEAM_ROOT . '/services/icm/Module.class.php');
	 define('PAGES_PER_GROUP', 20);
	 define('CIG_DEFAULT_RESULTS_PER_PAGE', 10);
	 
	 class editjob extends Module{
	 	
	 	function editjob() {}
	 	
	 	/**
	 	* @return boolean form was valid?
	 	* @param array $post
	 	* @desc implement this method to perform custom form validation
	 	*/
	 	function doValidate($post) {
	 		
	 			 		
			return $this->errorStatus();
	 	}
	 	
	 	/**
	 	* @return boolean setup was successful?
	 	* @param none
	 	* @desc implement this method to set any data needed by the tile on the
	 	* 		request
	 	*/
	 	function doSetup() {
	 		global $_DIR;
			include_once($_DIR['code_class']."/mainsearch.class.php");// include the main search class
			$searchObj = new mainsearch();	 // instantiate the class
			
	  	   if(!strlen($_REQUEST['page_num']) && empty($_GET ) && empty($_POST) && isset($_SESSION['editjob'])) {
				unset($_SESSION['editjob']); // clear all session
				
			}
			$idsdelimiter = "|";
			
			$resultsPerPage = CIG_DEFAULT_RESULTS_PER_PAGE;
			
		    
			$query = "getcompanies.qry";
			
			$query2run = $searchObj->buildGenericQuery($query, '');// build the query
			
			$comp = $searchObj->getRecordSet($query2run); // get the company name 
			
			$_REQUEST['companies'] = $comp;
	
          
			if(!strlen($_REQUEST['page_num'])) { // get the current page number from the url
				$currentPageNumber 	= 1;
				
			}
			else {
				$currentPageNumber 	= $_REQUEST['page_num'];	//Current Page number'
				
			}

			$_REQUEST['CURRENT_PAGE_NUMBER'] = $currentPageNumber; 
		  
			$_REQUEST['RESULT_PER_PAGE'] = $resultsPerPage;
			
			if(isset($_REQUEST['CURRENT_PAGE_NUMBER']) && !empty($_REQUEST['CURRENT_PAGE_NUMBER']))
			{
				
				if(!empty($_POST['company'])) {
					$_SESSION['editjob']['type'] = 'company';
					
				}
				else if(!empty($_POST['compname'])) {
					$_SESSION['editjob']['type'] = 'compname';
				
				}
				else if(!empty($_POST['compid'])) {
					$_SESSION['editjob']['type'] = 'compid';
					
				}
				else if ((isset($_POST['r1']) && $_POST['r1'] == 0) && ($_POST['company'] == '' && $_POST['compname'] == '' && $_POST['compid'] == '')) {
					$_SESSION['editjob']['type'] = '';
				
				}
		
				if(!empty($_POST['company']) || (!empty($_SESSION['editjob']['company']) && $_SESSION['editjob']['type'] == 'company'))
				{
					
					if(!empty($_SESSION['editjob']['company']) && empty($_POST['company'])) {
						
						$_POST['company'] = $_SESSION['editjob']['company'];
					    
						$args_array['sort'] = $_SESSION['editjob']['sort'];
					    $args_array['reverse'] = $_SESSION['editjob']['reverse'];
					  
					    
					}
				    if(isset($_REQUEST['sort']) && isset($_REQUEST['reverse'])) {
						$_POST['company'] = $_SESSION['editjob']['company'];
					   	
						$args_array['sort'] = $_REQUEST['sort'];
					    $args_array['reverse'] = $_REQUEST['reverse'];
					   
						$_SESSION['editjob']['sort']= $_REQUEST['sort'];
						$_SESSION['editjob']['reverse']= $_REQUEST['reverse'];
						
					    
					}
				    $_POST['r1'] = 1;
					$query = "jobs-sorted-by-compid.qry";
				    $args_array['status']='A';
					$args_array['compid'] = $_POST['company'];
					
					$args_array['page_number'] = $_REQUEST['CURRENT_PAGE_NUMBER'];
					$query2run = $searchObj->buildGenericQuery($query, $args_array);
				   
					$result = $searchObj->getRecordSet($query2run);
				
					$_REQUEST['jobs'] = $result;
				    
				   
					$_SESSION['editjob']['company'] = $_POST['company'];
					
				}
			  
				else if(!empty($_POST['compname']) || (!empty($_SESSION['editjob']['compname']) && $_SESSION['editjob']['type'] == 'compname'))
				{
					
				    
				    if(!empty($_SESSION['editjob']['compname']) && empty($_POST['compname'])) {
						$_POST['compname'] = $_SESSION['editjob']['compname'];
	                                        
						$args_array['sort'] = $_SESSION['editjob']['sort'];
					    $args_array['reverse'] = $_SESSION['editjob']['reverse'];
					  
						
					}
			        if(isset($_REQUEST['sort']) && isset($_REQUEST['reverse'])) {
						$_POST['company'] = $_SESSION['editjob']['company'];
						
						$_SESSION['editjob']['sort']= $_REQUEST['sort'];
						$_SESSION['editjob']['reverse']= $_REQUEST['reverse'];
						
				    	$args_array['sort'] = $_REQUEST['sort'];
					    $args_array['reverse'] = $_REQUEST['reverse'];
					    
					}
				    $_POST['r1'] = 1;
				    
				    $args_array['page_number'] = $_REQUEST['CURRENT_PAGE_NUMBER'];
				    $args_array['compname'] = $_POST['compname'];
				    $query = "jobs-sorted-by-compname.qry";
					
					
					$query2run = $searchObj->buildGenericQuery($query, $args_array);
					
					$result = $searchObj->getRecordSet($query2run);
					
					$_REQUEST['jobs'] = $result;
					
					$_SESSION['editjob']['compname'] = $_POST['compname'];
				}
				else if(!empty($_POST['compid']) || (!empty($_SESSION['editjob']['compid']) && $_SESSION['editjob']['type'] == 'compid'))
				{
					
					if(!empty($_SESSION['editjob']['compid']) && empty($_POST['compid'])) {
						$_POST['compid'] = $_SESSION['editjob']['compid'];
						$args_array['sort'] = $_SESSION['editjob']['sort'];
					    $args_array['reverse'] = $_SESSION['editjob']['reverse'];
					    
					    
					}
					if(isset($_REQUEST['sort']) && isset($_REQUEST['reverse'])) {
						
					
						$_SESSION['editjob']['sort']= $_REQUEST['sort'];
						$_SESSION['editjob']['reverse']= $_REQUEST['reverse'];
						$_POST['company'] = $_SESSION['editjob']['company'];
						$args_array['sort'] = $_REQUEST['sort'];
					    $args_array['reverse'] = $_REQUEST['reverse'];
					    
					}
				    $_POST['r1'] = 1;
				     $args_array['status']='A';
				    $args_array['compid'] = $_POST['compid'];
					
					$args_array['page_number'] = $_REQUEST['CURRENT_PAGE_NUMBER'];
				    $query = "jobs-sorted-by-compid.qry";
				    
					
					$query2run = $searchObj->buildGenericQuery($query, $args_array);
				    
					$result = $searchObj->getRecordSet($query2run);
					
					$_REQUEST['jobs'] = $result;
					
					$_SESSION['editjob']['compid'] = $_POST['compid']; 
			      
				}
			
			    if(is_array($result) && count($result) > 0)
				{
				    
					foreach($result as $id => $info) {
					    
					    
					 	$idLists .=  $idsdelimiter.$id; //Make the results ids string with the delimiter
					 	$jobqueryfile = "jobinfo.qry";
					    $args_array = array('job_id' => $id);
					    $jobrunquery = $searchObj->multipleBuildGenericQuery($jobqueryfile, $args_array);
				
					    $jobidarray = $searchObj->getRecordSet($jobrunquery);// get the description of eacg job depending on id
					    
					    if(is_array($jobidarray) && count($jobidarray) > 0)
					    {
							foreach($jobidarray as $jid => $jinfo)
							{
								
								$_REQUEST['jobs'][$jid] = $jinfo;
								
							}
					    }
					 	
					}
					$idLists = substr($idLists,1); //Removing first delimiter
				
				
					$_REQUEST['category_browse_result'] = $_REQUEST['jobs'];
				
				
				}
		
			 }
	
		
		
			$_REQUEST['pages'] = $searchObj->getPagination($info['rowtotal'], $_REQUEST['CURRENT_PAGE_NUMBER'], PAGES_PER_GROUP);// get the total number of pages 
		    
			$_REQUEST['page_setup'] = $searchObj->paginationSetup($_REQUEST['pages']['numPages'], $_REQUEST['CURRENT_PAGE_NUMBER'], $resultsPerPage, true, true);// set up the pagination for the page
			
	
            
			
	 		
	 		return true;
	 	}

	 	/**
	 	* @return boolean execution was successful?
	 	* @param array $post
	 	* @desc implement this method to process form data collected
	 	*/
	 	function doExecute($post) {

	 		return true;

	 	}	
	 }
?>