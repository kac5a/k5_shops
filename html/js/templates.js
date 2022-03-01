var buyMenu = `<div id="buymenu" class="menu-element">
              <i class="fa-solid fa-cart-shopping"></i>
              ${locale[lang].buyMenu}
            </div>`
var sellMenu = `<div id="sellmenu" class="menu-element">
              <i class="fa-solid fa-hand-holding-dollar"></i>
              ${locale[lang].sellMenu}
            </div>`
const genCard = (
  id,
  name,
  label,
  count,
  maxCount,
  price,
  inventoryCount,
  type,
  infinite,
  accountType
) => {
  return `<div class="card-container">
                  <div class="card-background ${
                    accountType == 3 ? 'blackmoney' : ''
                  }">
                    <div class="product-image">
                      <img src="img/${name}.png" />
                    </div>
                    <div class="product-data">
                      <div class="product-name ${
                        accountType == 3 ? 'blackmoney' : ''
                      }">${label}</div>
                      <div class="product-count">
                        <div class="price-count-current">${
                          !infinite ? count + locale[lang].countUnit : ''
                        }</div>
                        <div class="price-count-max">${
                          !infinite ? locale[lang].maxName + maxCount : ''
                        }</div>
                      </div>
                      <div class="product-price ${
                        accountType == 3 ? 'blackmoney' : ''
                      }">${price}${locale[lang].moneyUnit}</div>
                      <div class="product-buy">
                        <div class="buy-button buy-minus ${
                          type === 'buy'
                            ? count === 0 && !infinite
                              ? 'disabled'
                              : ''
                            : inventoryCount === 0 ||
                              (count === maxCount && !infinite)
                            ? 'disabled'
                            : ''
                        }" data-product="${name}" data-id="${id}">
                          <i class="fa-solid fa-minus"></i>
                        </div>
                        <input
                          class="product-price-input ${
                            type === 'buy'
                              ? count === 0 && !infinite
                                ? 'disabled'
                                : ''
                              : inventoryCount === 0 ||
                                (count === maxCount && !infinite)
                              ? 'disabled'
                              : ''
                          }"
                          value="0"
                          data-product="${name}"
                          data-id="${id}"
                          type="number"
                          name="count"
                          id="input-${name}"
                        />
                        <div class="buy-button buy-plus ${
                          type === 'buy'
                            ? count === 0 && !infinite
                              ? 'disabled'
                              : ''
                            : inventoryCount === 0 ||
                              (count === maxCount && !infinite)
                            ? 'disabled'
                            : ''
                        }" data-product="${name}" data-id="${id}">
                          <i class="fa-solid fa-plus"></i>
                        </div>
                      </div>
                    </div>
                  </div>
                </div>`
}

const genCartBuy = (cartData) => {
  let list = `<div class="details-list-title">${locale[lang].cartTitle}</div>`
  let total = 0
  for (const [key, _value] of Object.entries(cartData)) {
    if (cartData[key].count > 0) {
      list += `<div class="details-list-product">
                  <div class="details-list-product-name">${
                    cartData[key].count
                  } x ${cartData[key].label}</div>
                  <div class="details-list-product-price">${
                    cartData[key].buyPrice * cartData[key].count
                  }${locale[lang].moneyUnit}</div>
                </div>`
      total += cartData[key].buyPrice * cartData[key].count
    }
  }

  list += '</div>'

  return `<div class="details-list">
                ${list}
              <div class="details-total">
                <div class="details-totaltext">${locale[lang].total}:</div>
                <div class="details-totalprice">${total}${locale[lang].moneyUnit}</div>
              </div>
              <div class="details-action">
                <div id="pay-button">${locale[lang].buyButton}</div>
              </div>`
}

const genCartSell = (cartData) => {
  let list = `<div class="details-list-title">${locale[lang].sellListTitle}</div>`
  let total = 0
  for (const [key, _value] of Object.entries(cartData)) {
    if (cartData[key].count > 0) {
      list += `<div class="details-list-product">
                  <div class="details-list-product-name">${
                    cartData[key].count
                  } x ${cartData[key].label}</div>
                  <div class="details-list-product-price">${
                    cartData[key].sellPrice * cartData[key].count
                  }${locale[lang].moneyUnit}</div>
                </div>`
      total += cartData[key].sellPrice * cartData[key].count
    }
  }

  list += '</div>'

  return `<div class="details-list">
                ${list}
              <div class="details-total">
                <div class="details-totaltext">${locale[lang].total}:</div>
                <div class="details-totalprice">${total}${locale[lang].moneyUnit}</div>
              </div>
              <div class="details-action">
                <div id="pay-button">${locale[lang].sellButton}</div>
              </div>`
}
