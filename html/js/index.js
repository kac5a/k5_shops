var data
var cartData = {}

const getCartData = () => {
  cartData = {}
  Object.keys(data.items).forEach((key, index) => {
    cartData[key] = {
      label: data.items[key].label,
      count: 0,
      infinite: data.infinite,
      buyPrice: data.items[key].buyPrice,
      sellPrice: data.items[key].sellPrice,
      dbCount: data.items[key].count,
      max: data.items[key].maxCount,
      inventoryCount: data.items[key].inventoryCount,
    }
  })
}

window.addEventListener('message', function (event) {
  var msg = event.data
  if (msg.action == 'open') {
    data = msg.data
    open(data)
  }
  if (msg.action == 'reset') {
    data = msg.data
    open(data)
  }
  if (msg.action == 'close') {
    hideAll()
  }
})

$(() => {
  document.onkeyup = function (data) {
    if (data.which == 27) {
      closeEsc()
    }
  }
})

const open = (data) => {
  //Generate shop data
  closeModal()
  $('.menu-list').html('')
  $('.wrapper').css('display', 'flex')
  $('#shopname').html(data.shopName)
  $('#logo').attr('src', `img/${data.shopId}.png`)

  $('#exit-button').on('click', function () {
    close()
  })

  //Generate menu

  if (!data.sellOnly) {
    $('.menu-list').append(buyMenu)
    $('#buymenu').on('click', function () {
      setUpBuyPage(cartData)
    })
  }

  let isInJob = false
  if (data.sellJob) {
    data.sellJob.forEach((job) => {
      if (data.playerJob == job) isInJob = true
    })
  }

  if (isInJob || data.sellJob === undefined || data.sellOnly) {
    $('.menu-list').append(sellMenu)

    $('#sellmenu').on('click', function () {
      setUpSellPage()
    })
  }

  //Generate buy from shop grid
  data.sellOnly ? setUpSellPage() : setUpBuyPage(cartData)
}

const close = () => {
  $.post(
    'https://k5_shops/action',
    JSON.stringify({
      action: 'close',
    })
  )
}

const closeEsc = () => {
  if ($('.modal-wrapper').css('display') === 'flex') {
    $('.modal-wrapper').css('display', 'none')
  } else {
    $.post(
      'https://k5_shops/action',
      JSON.stringify({
        action: 'close',
      })
    )
  }
}

const hideAll = () => {
  $('.wrapper').css('display', 'none')
  $('.modal-wrapper').css('display', 'none')
}
