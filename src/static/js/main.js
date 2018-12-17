$( document ).ready(function() {
    $('#form-reg #form-chofer #reg-users').submit(function(e){
        e.preventDefault();
    });

	$('#reg-auto').click(function(){
		$.ajax({
			url: '/registro/auto',
			data: $('#form-reg').serialize(),
			type: 'POST',
			success: function(response){
                alert(response.message);
                location.reload();
			},
			error: function(error){
                alert(error.responseJSON.specific);
                console.log(error)
			}
		});
	});

	$('#reg-chofer').click(function(){
		$.ajax({
			url: '/registro/conductor',
			data: $('#form-chofer').serialize(),
			type: 'POST',
			success: function(response){
                alert(response.message);
                location.reload();
			},
			error: function(error){
                alert(error.responseJSON.error);
			}
		});
	});

	$('#form-users').click(function(){
		$.ajax({
			url: '/registro/conductor',
			data: $('#form-chofer').serialize(),
			type: 'POST',
			success: function(response){
                alert(response.message);
                location.reload();
			},
			error: function(error){
                alert(error.responseJSON.error);
			}
		});
	});
});
