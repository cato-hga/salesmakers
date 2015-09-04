$(document).ready(function () {

	$("#prepaid #sprint_sale_sprint_rate_plan_id option:contains('UPGRADE')").hide();

	function checkForUpgrade() {
		$("#sprint_sale_sprint_rate_plan_id").val('');
		$("#sprint_sale_sprint_rate_plan_id").show();
		var isUpgrade = $("#sprint_sale_upgrade").val() == 'true';
		var selectClass = $("#sprint_sale_sprint_carrier_id :selected").text();
		$('#sprint_sale_sprint_rate_plan_id option').show();
		$("#sprint_sale_sprint_rate_plan_id option:contains('UPGRADE'), #sprint_sale_sprint_rate_plan_id option:contains('Upgrade')").hide();
		if (isUpgrade) {
			$("#sprint_sale_sprint_rate_plan_id option:contains('UPGRADE')").prop('selected', true);
			if (selectClass == 'payLo') {
				$("#sprint_sale_sprint_rate_plan_id option:contains('Assurance Upgrade')").prop('selected', true);
			}
			$('#sprint_sale_sprint_rate_plan_id option').each(function () {
				if (($(this).text() != 'Assurance Upgrade') && ($(this).text() != 'PayLo Upgrade') && ($(this).text() != 'UPGRADE')) {
					$(this).hide();
				} else {
					$(this).show();
				}
			});
		}
	}

	$("#sprint_sale_upgrade").change(function () {
		checkForUpgrade();
	});

	$('#prepaid #sprint_sale_sprint_handset_id optgroup').hide();
	$("#prepaid #sprint_sale_sprint_rate_plan_id optgroup").hide();

	$("#prepaid #sprint_sale_sprint_carrier_id").change(function () {
		$('#prepaid #sprint_sale_sprint_handset_id optgroup').hide();
		$('#prepaid #sprint_sale_sprint_handset_id').val('');
		var carriers = $('#prepaid #sprint_sale_sprint_carrier_id :selected').text();
		$("#prepaid #sprint_sale_sprint_handset_id optgroup[label='" + carriers + "']").show();

		$("#prepaid #sprint_sale_sprint_rate_plan_id optgroup").hide();
		$("#prepaid #sprint_sale_sprint_rate_plan_id").val('');
		var carriers = $('#prepaid #sprint_sale_sprint_carrier_id :selected').text();
		$("#prepaid #sprint_sale_sprint_rate_plan_id optgroup[label='" + carriers + "']").show();
		checkForUpgrade();
	});

	$('#top_up_amount').hide();
	$('#prepaid #sprint_sale_top_up_card_amount').hide();

	$('#prepaid #sprint_sale_top_up_card_purchased').change(function () {
		var top_up_card_was_purchased = $('#prepaid #sprint_sale_top_up_card_purchased').val() == 'true';
		if (top_up_card_was_purchased) {
			$('#prepaid #sprint_sale_top_up_card_amount').show();
			$('#top_up_amount').show();
		} else {
			$('#prepaid #sprint_sale_top_up_card_amount').val('');
			$('#prepaid #sprint_sale_top_up_card_amount').hide();
			$('#top_up_amount').hide();
		}
	});

	$('#phone_not_activated').hide();
	$('#prepaid #sprint_sale_reason_not_activated_in_store').hide();

	$('#prepaid #sprint_sale_phone_activated_in_store').change(function () {
		var top_up_card_was_purchased = $('#prepaid #sprint_sale_phone_activated_in_store').val() == 'false';
		if (top_up_card_was_purchased) {
			$('#prepaid #sprint_sale_reason_not_activated_in_store').show();
			$('#phone_not_activated').show();
		} else {
			$('#prepaid #sprint_sale_reason_not_activated_in_store').val('');
			$('#prepaid #sprint_sale_reason_not_activated_in_store').hide();
			$('#phone_not_activated').hide();
		}
	});

	$('#additional_features').hide();

	$("#prepaid #sprint_sale_sprint_carrier_id").change(function () {
		$('#prepaid #sprint_sale_five_intl_connect').val('');
		$('#prepaid #sprint_sale_ten_intl_connect').val('');
		$('#prepaid #sprint_sale_insurance').val('');
		$('#additional_features').hide();
		var boost = $('#prepaid #sprint_sale_sprint_carrier_id :selected').text() == 'Boost Mobile';
		if (boost) {
			$('#additional_features').show();
		}
	});

	$('#add_ons').hide();

	$("#prepaid #sprint_sale_sprint_carrier_id").change(function () {
		$('#prepaid #sprint_sale_virgin_data_share_add_on_amount').val('');
		$('#prepaid #sprint_sale_virgin_data_share_add_on_description').val('');
		$('#add_ons').hide();
		var virgin_data_share = $('#prepaid #sprint_sale_sprint_carrier_id :selected').text() == 'Virgin Mobile Data Share';
		if (virgin_data_share) {
			$('#add_ons').show();
		}
	});
});