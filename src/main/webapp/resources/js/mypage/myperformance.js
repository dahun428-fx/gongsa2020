let isLast = false
$(function () {

    $(window).scroll(() => {
        const scrollTop = $(window).scrollTop()
        const windowHeight = $(window).height()
        const docHeight = $(document).height()

        if(scrollTop > docHeight - windowHeight - 30){
            generateList()
        }
    })
    generateList()
    

    $("#mypagemenu li").click((event) => {
        const url = $(event.target).data('href')
        $(location).attr('href', url)
    })

    $(document).on('click', '.reserve-list', function (event) {
        const reserveId = $(this).data('reserveId')
        const url = `/mypage/myperformanceDetail.do?reserveId=${reserveId}`
        const sendvalue = {'reserveId': reserveId}

        $(location).attr('href', url)

    })
}).ajaxStart(() => {
}).ajaxStop(() => {
})

let currNo = 0
let dateToYMD = function (date) {
    return `${date.getFullYear()}.${date.getMonth()}.${date.getDate()}`;
}
let generateList = function () {
    if (isLast) {
        return
    }
    let data = {
        id: $('#login-user-id').text(),
        point : currNo
    }
    $.ajax({
        url: '/mypage/myperformance.do',
        type: 'POST',
        contentType: 'application/json; charset=utf-8',
        data: JSON.stringify(data),
        dataType: 'json'
    }).done(result => {
        let reserves = result.reserves
        if(reserves.length < 5){
            isLast = true
        }
        currNo += reserves.length

        if (reserves.length) {
            let template = $('#myperformance-list-template').clone()
            reserves.forEach(reserve => {
                const performance = reserve.performance
                const user = reserve.reserveUser
                const mate = reserve.mate
                const newId = `myperformance-list-${reserve.id}`
                const regDate = new Date(reserve.regDate)
                const startDate = new Date(performance.startDate)
                const endDate = new Date(performance.endDate)
                template.attr("id", newId)
                template.attr("data-reserve-id", reserve.id)
                template.addClass('reserve-list')
                $(".container").append($(template).clone())
                var imagePath = `${performance.imagePath}`;
                if(imagePath.substring(0,4) != 'http'){
                	imagePath = `/resources/sample-images/${performance.imagePath}`;
                }
                $(`#${newId} .performance-image`).attr("src", imagePath);
               
                console.log(`#${newId} .performance-image` + ' src : ' + `/resources/sample-images/${performance.imagePath}`)
                $(`#${newId} .performance-title`).text(performance.title)
                $(`#${newId} .performance-reg-date`).text(dateToYMD(regDate))
                $(`#${newId} .performance-start-date`).text(dateToYMD(startDate))
                $(`#${newId} .performance-end-date`).text(dateToYMD(endDate))
                $(`#${newId} .performance-hall-name`).text(performance.schedule[0].hallinfo.name)
                $(`#${newId} .performance-reserve-user`).text(user.nickname)
                $(`#${newId} .performance-reserve-status`).text(reserve.status)
                if (mate) {
                    $(`${newId} .performance-ticket-no`).text(`${mate.seatGroup}${mate.seatRate}${regDate.getMonth()}${regDate.getDay()}`)
                }
                $(`#${newId}`).removeClass("d-none")

            })

        } else {
            $('#myperformance-reserve-null').removeClass("d-none")
        }
    }).fail(function () {

    }).always(function () {

    })

}