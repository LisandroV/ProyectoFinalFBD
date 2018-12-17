$( document ).ready(function() {
    $('#form-reg #form-chofer #form-users').submit(function(e){
        e.preventDefault();
    });

    $('#form-users').submit(function(e){
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
                alert(error.responseJSON.error);
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

	$('#reg-users').click(function(){
		$.ajax({
			url: '/registro/users',
			data: $('#form-users').serialize(),
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
