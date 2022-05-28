const setUpBuyPage = () => {
  //Generate menu
  $('.menu-element').removeClass('active')
  $('#buymenu').addClass('active')
  $('.grid').html('')

  //Generate grid cards
  Object.keys(data.items)
    .sort(function (a, b) {
      if (data.items[a].label < data.items[b].label) {
        return -1
      }
      if (data.items[a].label > data.items[b].label) {
        return 1
      }
      return 0
    })
    .forEach((key, i) => {
      if (data.items[key].buyPrice !== undefined) {
        $('.grid').append(
          genCard(
            i,
            key,
            data.items[key].label,
            data.items[key].count,
            data.items[key].maxCount,
            data.items[key].buyPrice,
            data.items[key].inventoryCount,
            'buy',
            data.infinite,
            data.paymentType
          )
        )
      }
    })

  getCartData()
  $('.details').html(genCartBuy(cartData))
  setBuyButton()

  //Add grid card button functionalities
  $('.buy-minus').on('click', function () {
    let productName = $(this).data('product')
    let oldValue = cartData[productName].count

    let newValue = parseInt(oldValue) - 1

    if (newValue >= 0) {
      $(`.product-price-input[data-product="${productName}"]`).val(newValue)
      cartData[productName].count = parseInt(newValue)
      $('.details').html(genCartBuy(cartData))
      setBuyButton()
    }
  })

  $('.buy-plus').on('click', function () {
    let productName = $(this).data('product')
    if (data.infinite) {
      let oldValue = cartData[productName].count
      let newValue = parseInt(oldValue) + 1
      $(`.product-price-input[data-product="${productName}"]`).val(newValue)
      cartData[productName].count = parseInt(newValue)
      $('.details').html(genCartBuy(cartData))
      setBuyButton()
    } else if (cartData[productName].dbCount > 0) {
      let oldValue = cartData[productName].count

      let newValue = parseInt(oldValue) + 1

      if (newValue <= cartData[productName].dbCount) {
        $(`.product-price-input[data-product="${productName}"]`).val(newValue)
        cartData[productName].count = parseInt(newValue)
        $('.details').html(genCartBuy(cartData))
        setBuyButton()
      }
    }
  })

  $('.product-price-input').on('input', function () {
    let productName = $(this).data('product')

    $(this).val(Math.round($(this).val()))

    if (data.infinite) {
      if ($(this).val() < 0) {
        $(this).val(0)
      }

      cartData[productName].count = parseInt($(this).val())
      $('.details').html(genCartBuy(cartData))
      setBuyButton()
    } else {
      if ($(this).val() > cartData[productName].dbCount) {
        $(this).val(cartData[productName].dbCount)
      }
      if ($(this).val() < 0) {
        $(this).val(0)
      }
      cartData[productName].count = parseInt($(this).val())
      $('.details').html(genCartBuy(cartData))
      setBuyButton()
    }
  })
}

const setBuyButton = () => {
  $('#pay-button').html(locale[lang].buyButton)
  $('#pay-button').unbind()
  $('#pay-button').on('click', function () {
    openModal(
      locale[lang].buyTitle,
      locale[lang].buyQuestion,
      function () {
        let payData = Object.keys(cartData)
          .filter((key) => cartData[key].count > 0)
          .map((key) => ({
            name: key,
            amount: cartData[key].count,
            price: cartData[key].buyPrice,
          }))
        let totalPrice = 0
        Object.keys(cartData)
          .filter((key) => cartData[key].count > 0)
          .forEach((key) => {
            totalPrice += cartData[key].buyPrice * cartData[key].count
          })

        if (payData.length) {
          $.post(
            'https://k5_shops/action',
            JSON.stringify({
              action: 'buyItems',
              data: {
                shopName: data.shopId,
                price: totalPrice,
                paymentType: data.paymentType,
                payData: payData,
              },
            })
          )
        } else {
          openModal(locale[lang].error, locale[lang].emptyCart)
        }
      },
      closeModal,
      locale[lang].yes,
      locale[lang].cancel
    )
  })
}
