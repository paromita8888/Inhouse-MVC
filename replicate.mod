<?php

	/*
	 * editjob.mod
	 * used to replicate jobs  for active employers
	 * 
	 * 
	 * The mod file acts as a controller file similar in CakePHP framework. 
	 * 
	 */
	 require_once(IBEAM_ROOT . '/services/icm/Module.class.php'); 
	 define('PAGES_PER_GROUP', 20);
	 define('CIG_DEFAULT_RESULTS_PER_PAGE', 10);
	 
	 class replicate extends Module{
	 	
	 	function replicate() {}
	 	
	 	/**
	 	* @return boolean form was valid
	 	* @param array $post
	 	* @desc implement this method to perform custom form validation
	 	*/
	 	function doValidate($post) {
	 		
	 		
			return true;
	 	}
	 	
	 	/**
	 	* @return boolean setup was successful?
	 	* @param none
	 	* @desc implement this method to set any data needed by the tile on the
	 	* 		request
	 	*/
	 	function doSetup() {
	 		global $_DIR;
			include_once($_DIR['code_class']."/mainsearch.class.php"); // the main search class is included 
			$searchObj = new mainsearch();	// the search class is instaniated
		
	
			if(!strlen($_REQUEST['page_num']) && empty($_GET ) && empty($_POST) && isset($_SESSION['replicate'])) {
				unset($_SESSION['replicate']);
				
			}
			$idsdelimiter = "|";
			
			$resultsPerPage = CIG_DEFAULT_RESULTS_PER_PAGE;
			
			$query = "getcompanies.qry"; // gets the company id which are active
			$query2run = $searchObj->buildGenericQuery($query, '');
			$comp = $searchObj->getRecordSet($query2run);
			
			$_REQUEST['companies'] = $comp;
			
			$statequery = 'getstates.qry';
			$query2run = $searchObj->buildGenericQuery($statequery, '');
			$state = $searchObj->getRecordSet($query2run);
			
			$_REQUEST['states'] = $state;
	

			if(!strlen($_REQUEST['page_num'])) {
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
					$_SESSION['replicate']['type'] = 'company';
					
				}
				else if(!empty($_POST['compname'])) {
					$_SESSION['replicate']['type'] = 'compname';
				
				}
				else if(!empty($_POST['compid'])) {
					
					$_SESSION['replicate']['type'] = 'compid';
					
					
				}
				else if ((isset($_POST['r1']) && $_POST['r1'] == 0) && ($_POST['company'] == '' && $_POST['compname'] == '' && $_POST['compid'] == '')) {
					$_SESSION['replicate']['type'] = '';
				
				}
				if(!empty($_POST['company']) || (!empty($_SESSION['replicate']['company']) && $_SESSION['replicate']['type'] == 'company'))
				{
					
					if(!empty($_SESSION['replicate']['company']) && empty($_POST['company'])) {
						$_POST['company'] = $_SESSION['replicate']['company'];
					
						$args_array['sort'] = $_SESSION['replicate']['sort'];
					    $args_array['reverse'] = $_SESSION['replicate']['reverse'];
					}
				    if(isset($_REQUEST['sort']) && isset($_REQUEST['reverse'])) {
						$_POST['company'] = $_SESSION['replicate']['company'];
						$args_array['sort'] = $_REQUEST['sort'];
					    $args_array['reverse'] = $_REQUEST['reverse'];
					    $_SESSION['replicate']['sort']= $_REQUEST['sort'];
						$_SESSION['replicate']['reverse']= $_REQUEST['reverse'];
					    
					}
					$_POST['r1'] = 1;
					$query = "jobs-sorted-by-compid.qry"; 
					
					$args_array['compid'] = $_POST['company'];
					$args_array['status']='A';
					$args_array['page_number'] = $_REQUEST['CURRENT_PAGE_NUMBER'];
					
					$query2run = $searchObj->buildGenericQuery($query, $args_array);
				  
					$result = $searchObj->getRecordSet($query2run);
					
					$_REQUEST['jobs'] = $result;
					
					$_SESSION['replicate']['company'] = $_POST['company'];
					
				}
				else if(!empty($_POST['compname']) || (!empty($_SESSION['replicate']['compname']) && $_SESSION['replicate']['type'] == 'compname'))
				{
					
				    
				    if(!empty($_SESSION['replicate']['compname']) && empty($_POST['compname'])) {
						$_POST['compname'] = $_SESSION['replicate']['compname'];
					   
						$args_array['sort'] = $_SESSION['replicate']['sort'];
					    $args_array['reverse'] = $_SESSION['replicate']['reverse'];
					}
			        if(isset($_REQUEST['sort']) && isset($_REQUEST['reverse'])) {
						$_POST['company'] = $_SESSION['replicate']['company'];
						
						$_SESSION['replicate']['sort']= $_REQUEST['sort'];
						$_SESSION['replicate']['reverse']= $_REQUEST['reverse'];
						
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
				
					
					$_SESSION['replicate']['compname'] = $_POST['compname'];
				}
				else if(!empty($_POST['compid']) || (!empty($_SESSION['replicate']['compid']) && $_SESSION['replicate']['type'] == 'compid'))
				{
					
					if(!empty($_SESSION['replicate']['compid']) && empty($_POST['compid'])) {
						$_POST['compid'] = $_SESSION['replicate']['compid'];
						
						$args_array['sort'] = $_SESSION['replicate']['sort'];
					    $args_array['reverse'] = $_SESSION['replicate']['reverse'];
					}
					if(isset($_REQUEST['sort']) && isset($_REQUEST['reverse'])) {
					
						$_POST['company'] = $_SESSION['replicate']['company'];
						$args_array['sort'] = $_REQUEST['sort'];
					    $args_array['reverse'] = $_REQUEST['reverse'];
					    
					    $_SESSION['editjob']['sort']= $_REQUEST['sort'];
						$_SESSION['editjob']['reverse']= $_REQUEST['reverse'];
					    
					}
				    $_POST['r1'] = 1;
				    
				    $args_array['compid'] = $_POST['compid'];
					 $args_array['status']='A';
					$args_array['page_number'] = $_REQUEST['CURRENT_PAGE_NUMBER'];
				    $query = "jobs-sorted-by-compid.qry";
				    
					
					$query2run = $searchObj->buildGenericQuery($query, $args_array);
				    
					$result = $searchObj->getRecordSet($query2run);
					
					$_REQUEST['jobs'] = $result;
					
					$_SESSION['replicate']['compid'] = $_POST['compid']; 
				
			      
					
				}
				
			if(is_array($result) && count($result) > 0)
				{
				    
					foreach($result as $id => $info) {
					    
					    
					 	$idLists .=  $idsdelimiter.$id; //Make the results ids string with the delimiter
					 	$jobqueryfile = "jobinfo.qry";
					    $args_array = array('job_id' => $id);
					    $jobrunquery = $searchObj->multipleBuildGenericQuery($jobqueryfile, $args_array);
				
					    $jobidarray = $searchObj->getRecordSet($jobrunquery);
					    
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
		
			
			$_REQUEST['pages'] = $searchObj->getPagination($info['rowtotal'], $_REQUEST['CURRENT_PAGE_NUMBER'], PAGES_PER_GROUP); // get the total number of pages 
			$_REQUEST['page_setup'] = $searchObj->paginationSetup($_REQUEST['pages']['numPages'], $_REQUEST['CURRENT_PAGE_NUMBER'], $resultsPerPage, true, true);
			//set up the pagination
		

			if(strlen($_REQUEST['CURRENT_PAGE_NUMBER']) == 0)
			{
			     $_REQUEST['CURRENT_PAGE_NUMBER'] = 1;
			}
				
			$_REQUEST['view'] = 1;
			
			if(!empty($_POST['job']))
			{
				$_REQUEST['view'] = 2;
			}
			
			if(!empty($_POST['amt']))
			{
				$query = 'getjobbyid.qry';
				$args_array['jid'] = $_POST['job'];
				$query2run = $searchObj->buildGenericQuery($query, $args_array);
				$result = $searchObj->getRecordSet($query2run);
				
				$_REQUEST['jinfo'] = $result;
			
				$_REQUEST['view'] = 3;
			}
			
			if($_POST['rep'] == 1)
			{
				$k = 0;
				for($i = 1; $i <= $_POST['amt']; $i++)
				{
					if($_POST['zip' . $i] == '')
					{
						$_REQUEST['error'][$k] = 'You must enter a zip code for Job ' . $i;
						$k++;
					}
					
					$query = 'validate_address.qry';
					$args_array['zip_code'] = $_POST['zip' . $i];
					$args_array['city_name'] = $_POST['city' . $i];
					
					$statecode= getStateCode($_POST['staten'.$i]);
                    
					$args_array['state_code'] = $statecode;
					$query2run = $searchObj->multipleBuildGenericQuery($query, $args_array);
					$result = $searchObj->getRecordSet($query2run);
				   
					if(empty($result))
					{
						$_REQUEST['error'][$k] = 'Address for Job ' . $i . ' does not exist';
					
						$k++;
					}
				}
				if($k == 0)
				{
					for($j = 1; $j <= $_POST['amt']; $j++)
					{
						$query = 'replicatejob.qry';
						$args_array['jid'] = $_POST['job'];
						$args_array['jobcode'] = $_POST['job_code' . $j];
						$args_array['city_name'] = $_POST['city' . $j];
						$args_array['zip_code'] = $_POST['zip' . $j];
						
						$statecode= getStateCode($_POST['staten'.$j]);
					
						$args_array['state_code'] = $statecode;
					      
						$query2run = $searchObj->multipleBuildGenericQuery($query, $args_array);
						 
						$result = $searchObj->getRecordCol($query2run);
					}
					$_REQUEST['success'] = 1;
					
		        
				}
			}
	 		
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