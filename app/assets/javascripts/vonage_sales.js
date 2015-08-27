function hideMAC() {
	$('#vonage_sale_mac').css('visibility', 'hidden');
	$('#mac_id').css('visibility', 'hidden');
}

$(document).ready(function () {

	$('#vonage_sale_mac_confirmation').focusin(function () {
		if ($('#vonage_sale_mac_confirmation').val().toUpperCase() == $('#vonage_sale_mac').val().toUpperCase()) return;
		hideMAC();
		$('#vonage_sale_mac_confirmation').after('<div class="helpText" style="color: red;">MAC ID will reappear after this confirmation is entered.</span>');
	});

	$('#vonage_sale_mac_confirmation').keyup(function () {
		if ($('#vonage_sale_mac_confirmation').val().toUpperCase() == $('#vonage_sale_mac').val().toUpperCase()) {
			$('#vonage_sale_mac').css('visibility', 'visible');
			$('#mac_id').css('visibility', 'visible');
			$('.helpText').remove();
		} else {
			hideMAC();
		}
	});

	$('#vonage_sale_mac_confirmation').focusout(function () {
		$('#vonage_sale_mac').css('visibility', 'visible');
		$('#mac_id').css('visibility', 'visible');
		$('.helpText').remove();
	});

	$('#vonage_sale_mac').focusin(function () {
		if ($('#vonage_sale_mac').val().length < 12) {
			$('#vonage_sale_mac_confirmation').css('visibility', 'hidden');
			$('#mac_id_conf').css('visibility', 'hidden');
			$('#vonage_sale_mac').after('<div class="helpText" style="color: red;">MAC ID Confirmation box will reappear after this MAC ID is entered.</span>');
		}
	});

	$('#vonage_sale_mac').keyup(function () {
		if ($('#vonage_sale_mac').val().length > 11) {
			$('#vonage_sale_mac_confirmation').css('visibility', 'visible');
			$('#mac_id_conf').css('visibility', 'visible');
			$('.helpText').remove();
		}
	});
});

$(function () {
	$("#vonage_sale_vonage_product_id").change(function () {
		var home_kit = $("#vonage_sale_vonage_product_id").val() == 2;
		var blank_product_type = $("#vonage_sale_vonage_product_id").val() == '';
		if (home_kit) {
			$('#gcn').show();
			$('#gcnc').show();
			$($("#vonage_sale_gift_card_number")).show();
			$($("#vonage_sale_gift_card_number_confirmation")).show();
		} else if (blank_product_type) {
			$('#gcn').show();
			$('#gcnc').show();
			$($("#vonage_sale_gift_card_number")).show();
			$($("#vonage_sale_gift_card_number_confirmation")).show();
		} else {
			$('#gcn').hide();
			$('#gcnc').hide();
			$($("#vonage_sale_gift_card_number")).val('');
			$($("#vonage_sale_gift_card_number")).hide();
			$($("#vonage_sale_gift_card_number_confirmation")).val('');
			$($("#vonage_sale_gift_card_number_confirmation")).hide();
		}
	})
});






