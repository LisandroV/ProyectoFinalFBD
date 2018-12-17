$( document ).ready(function() {
    $('#form-reg').submit(function(e){
        e.preventDefault();
    });

	$('#registrar').click(function(){
		$.ajax({
			url: '/registro/auto',
			data: $('#form-reg').serialize(),
			type: 'POST',
			success: function(response){
                alert(response.message);
			},
			error: function(error){
                alert(error.responseJSON.specific);
                console.log(error)
			}
		});
	});
});
