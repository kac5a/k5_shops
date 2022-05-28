const setUpSellPage = () => {
  $('.menu-element').removeClass('active')
  $('#sellmenu').addClass('active')
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
      if (data.items[key].sellPrice !== undefined) {
        $('.grid').append(
          genCard(
            i,
            key,
            data.items[key].label,
            data.items[key].count,
            data.items[key].maxCount,
            data.items[key].sellPrice,
            data.items[key].inventoryCount,
            'sell',
            data.infinite,
            data.paymentType
          )
        )
      }
    })

  getCartData()
  $('.details').html(genCartSell(cartData))
  setSellButton()

  //Add grid card button functionalties
  $('.buy-minus').on('click', function () {
    let productName = $(this).data('product')
    let oldValue = cartData[productName].count

    let newValue = parseInt(oldValue) - 1
    if (newValue >= 0) {
      $(`.product-price-input[data-product="${productName}"]`).val(newValue)
      cartData[productName].count = parseInt(newValue)
      $('.details').html(genCartSell(cartData))
      setSellButton()
    }
  })

  $('.buy-plus').on('click', function () {
    let productName = $(this).data('product')
    let oldValue = cartData[productName].count

    let newValue = parseInt(oldValue) + 1

    if (newValue <= cartData[productName].inventoryCount) {
      if (!data.infinite) {
        if (
          newValue <=
          cartData[productName].max - cartData[productName].dbCount
        ) {
          $(`.product-price-input[data-product="${productName}"]`).val(newValue)
          cartData[productName].count = parseInt(newValue)
          $('.details').html(genCartSell(cartData))
          setSellButton()
        }
      } else {
        $(`.product-price-input[data-product="${productName}"]`).val(newValue)
        cartData[productName].count = parseInt(newValue)
        $('.details').html(genCartSell(cartData))
        setSellButton()
      }
    }
  })

  $('.product-price-input').on('input', function () {
    let productName = $(this).data('product')

    $(this).val(Math.round($(this).val()))

    if ($(this).val() > cartData[productName].inventoryCount) {
      if (
        data.infinite ||
        cartData[productName].inventoryCount <
          cartData[productName].max - cartData[productName].dbCount
      ) {
        $(this).val(cartData[productName].inventoryCount)
      } else {
        $(this).val(cartData[productName].max - cartData[productName].dbCount)
      }

      cartData[productName].count = parseInt($(this).val())
      $('.details').html(genCartSell(cartData))
      setSellButton()
      return
    }

    if (
      !data.infinite &&
      $(this).val() > cartData[productName].max - cartData[productName].dbCount
    ) {
      $(this).val(cartData[productName].max - cartData[productName].dbCount)
    }

    if ($(this).val() < 0) {
      $(this).val(0)
    }
    cartData[productName].count = parseInt($(this).val())
    $('.details').html(genCartSell(cartData))
    setSellButton()
  })
}

const setSellButton = () => {
  $('#pay-button').html(locale[lang].sellButton)
  $('#pay-button').unbind()
  $('#pay-button').on('click', function () {
    openModal(
      locale[lang].sellTitle,
      locale[lang].sellQuestion,
      function () {
        let payData = Object.keys(cartData)
          .filter((key) => cartData[key].count > 0)
          .map((key) => ({
            name: key,
            amount: cartData[key].count,
            price: cartData[key].sellPrice,
          }))
        if (payData.length) {
          $.post(
            'https://k5_shops/action',
            JSON.stringify({
              action: 'sellItems',
              data: {
                shopName: data.shopId,
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
