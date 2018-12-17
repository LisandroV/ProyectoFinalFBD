$( document ).ready(function() {

	$('#registrar').click(function(){
        console.log($('#form-reg').serialize());
		$.ajax({
			url: '/registro/auto',
			data: {'marca': 'masserati'},
			type: 'POST',
			success: function(response){
                alert("GOOD");
				alert(response);
			},
			error: function(error){
				alert(error);
				console.log(error);
			}
		});
	});
});
