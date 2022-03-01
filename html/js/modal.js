const openModal = (
  title,
  content,
  onSubmit,
  onCancel = closeModal,
  okTitle = 'OK',
  cancelTitle = locale[lang].close
) => {
  $('.modal-wrapper').css('display', 'flex')
  $('.modal-title').html(title)
  $('.modal-content').html(content)
  $('.modal-ok').html(okTitle)
  $('.modal-cancel').html(cancelTitle)
  $('.modal-ok').unbind()
  $('.modal-cancel').unbind()
  if (onSubmit) {
    $('.modal-ok').css('display', 'flex')
    $('.modal-ok').on('click', onSubmit)
  } else {
    $('.modal-ok').css('display', 'none')
  }
  $('.modal-cancel').on('click', onCancel)
}

const closeModal = () => {
  $('.modal-wrapper').css('display', 'none')
}
