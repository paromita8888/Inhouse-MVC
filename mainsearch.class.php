<?PHP
class mainsearch
{

	function mainsearch()
	{}
   
        
	/***
    The function calculates the number of pages on the basis of total number of jobs returned by the query in the .mod file 
	****/
	function getPagination($jobCount, $iPage, $iGroupSize) {
		$cntr = 0;
		$aHitArray = Array();
		$sPageInfo = Array('numPages' => 0,
		'numHits' => 0,
		'start' => 0,
		'end' => 0,
		'displayPage' => $iPage);
		
		//	Determine how many total pages exists, which	page to display, what nav buttons are needed.
		$sPageInfo['numHits'] = $jobCount;
		//  Do page calculation ONLY IF there are more hits to display than will fit on a single page.
		if ($sPageInfo['numHits'] > $iGroupSize) //  Search produced more hits than will fit on one page.
		{
			$sPageInfo['numPages'] = ceil($sPageInfo['numHits'] / $iGroupSize);
		}
		else //  Value List will fit in one group
		{
			$sPageInfo['numPages'] = 1;
		}

		// if the page is not a number make it 1
		if (!is_numeric($iPage)) { $iPage = 1; }
		// if page requested is greater than the set allow make it last set in data.
		if ($iPage > $sPageInfo['numPages']) { $iPage = $sPageInfo['numPages']; }
		// if page requested less than 1 make it 1.
		if ($iPage < 1 ) { $iPage = 1; }
		/* From the entire list of hits, select the slice we need to display
		on the page we're preparing. We convert the list to an array just
		for convenience.*/
		$sPageInfo['end'] = $iPage * $iGroupSize; 	// Theoretical end.
		$sPageInfo['start'] = $sPageInfo['end'] - $iGroupSize + 1; 	// Determine start from theoretical end.
		if ($sPageInfo['end'] > $sPageInfo['numHits'])   //  Actual end.  (The last page might contain only a partial list.)
		{ $sPageInfo['end'] = $sPageInfo['numHits']; }
		/*  Take a slice of the array, put values in a LIST.  The list contains the
		id's we will actually display on this page. */
		$sPageInfo['aDisplayList'] = array_slice($aHitArray, $sPageInfo['start']-1, $iGroupSize);
		$sPageInfo['lDisplayList'] = implode(",", $sPageInfo['aDisplayList']);
		$sPageInfo['displayPage'] = $iPage;
		//  End of page calculation code.  Now return the pagination results.
		return $sPageInfo;
	}//function pageCalculate($Values, $delimiter, $iPage, $iGroupSize)
	
	/***
    
	 /**
		 * @Function name = paginationSetup
		 This function sets up the pagination labels
	 	
		 */
	function paginationSetup($num_pages=1, $current_page=1, $pages_per_group=10, $next_prev = true, $first_last = false) {
		$Info = Array();
		$bDoMath = true;
		if (!is_numeric($num_pages) || $num_pages <=0)
		{ $bDoMath = false; }
		if ($bDoMath)
		{
			// make sure we have valid value for pages per group
			if (!is_numeric($pages_per_group) || $pages_per_group <= 0)
			{ $pages_per_group = 10; }
			// make sure the current page value is valid.
			if (!is_numeric($current_page))
			{ $current_page = 1; }
			elseif ($current_page <= 0)
			{ $current_page = 1; }
			elseif ($current_page > $num_pages)
			{ $current_page = $num_pages; }
			$previous_group = 0;
			$current_group = 0;
			$next_group = 0;
			// loop from 1 to $num pages
			$group = 1;
			$arrGroup = Array();
			for ($i = 1; $i <= $num_pages; $i++)
			{
				// if current_group has not been created
				if (!isset($arrGroup[$group])) { $arrGroup[$group] = Array(); }
				// add this page to it's group
				$arrGroup[$group][] = $i;
				if ($i == $current_page)
				{
					$previous_group = $group - 1;
					$current_group = $group;
					$next_group = $group + 1;
				}
				// if this group is complete prep for the next one.
				if (count($arrGroup[$group]) >= $pages_per_group)
				{ $group += 1; }
			}
			//debug($arrGroup);
			// if we have a previous group load item
			if ($previous_group > 0 && isset($arrGroup[$previous_group]))
			{
				$pStart = array_shift($arrGroup[$previous_group]);
				$pEnd = array_pop($arrGroup[$previous_group]);
				$pThisSection = Array('label' => $pStart . ' - ' . $pEnd, 'page' => $pEnd);
				$Info[] = $pThisSection;
			}

			// if we have current group load group
			if ($current_group > 0 && isset($arrGroup[$current_group]))
			{
				while(list($key, $val) = each($arrGroup[$current_group]))
				{
					$Info[] = Array('label' => $val, 'page' => $val);
				}
			}

			// if we have a previous group load item
			if ($next_group > 0 && isset($arrGroup[$next_group]))
			{
				$nStart = array_shift($arrGroup[$next_group]);
				$nEnd = array_pop($arrGroup[$next_group]);
				$nThisSection = Array('label' => $nStart . ' - ' . $nEnd, 'page' => $nStart);
				$Info[] = $nThisSection;
			}
		} // if ($bDoMath)

		if($next_prev)
		{
			if($current_page < $num_pages)
			{
				$next_array['label'] 	= 	"Next";
				$next_array['page'] 		= 	$current_page+1;
			}

			if($current_page > 1)
			{
				$previous_array['label'] 	= 	"Previous";
				$previous_array['page'] 	= 	$current_page-1;
			}
			$Info[] = $next_array;
			$temp_store[0] = $previous_array;
			foreach($Info as $val)
			{
				$temp_store[] = $val;
			}
		}

		if($first_last) {
			$first_array['label']           =   "First";
			$first_array['page']            =   1;

			$last_array['label']            =   "Last";
			$last_array['page']             =   $num_pages;

			$temp_array[0] = $first_array;
			foreach($temp_store as $val) {
				$temp_array[] = $val;
			}
			$temp_array[] = $last_array;

			$temp_store = $temp_array;
		}
		return $temp_store;
	}//function paginationSetup($num_pages=1, $current_page=1, $pages_per_group=10)
}//class mainsearch

?>