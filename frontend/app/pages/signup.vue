<script setup lang="ts">
const route = useRoute()
const { signup } = useAuth()
const name = ref('')
const email = ref('')
const password = ref('')
const passwordConfirmation = ref('')
const submitting = ref(false)
const errorMessage = ref('')

const redirectPath = computed(() => {
  const redirect = typeof route.query.redirect === 'string' ? route.query.redirect : ''
  return redirect.startsWith('/') && !redirect.startsWith('//') ? redirect : '/practice/1/1'
})

const submit = async () => {
  if (submitting.value) return
  if (password.value !== passwordConfirmation.value) {
    errorMessage.value = '確認用パスワードが一致していません。'
    return
  }

  submitting.value = true
  errorMessage.value = ''
  try {
    await signup({
      name: name.value,
      email: email.value,
      password: password.value,
      password_confirmation: passwordConfirmation.value,
    })
    await navigateTo(redirectPath.value)
  }
  catch (error: any) {
    errorMessage.value = error?.data?.error?.message ?? '会員登録できませんでした。入力内容を確認してください。'
  }
  finally {
    submitting.value = false
  }
}
</script>

<template>
  <div class="page-wrap auth-page">
    <header class="page-intro"><h1>会員登録</h1><p>登録後は、解答履歴とお気に入りを利用できます。</p></header>
    <form class="content-panel auth-form" @submit.prevent="submit">
      <div class="field"><label for="name">ユーザー名</label><input id="name" v-model="name" autocomplete="name" type="text" required></div>
      <div class="field"><label for="email">メールアドレス</label><input id="email" v-model="email" autocomplete="email" type="email" required></div>
      <div class="field"><label for="password">パスワード</label><input id="password" v-model="password" autocomplete="new-password" type="password" minlength="8" required></div>
      <div class="field"><label for="password-confirmation">確認用パスワード</label><input id="password-confirmation" v-model="passwordConfirmation" autocomplete="new-password" type="password" minlength="8" required></div>
      <p v-if="errorMessage" class="form-error" role="alert">{{ errorMessage }}</p>
      <button class="primary-link" type="submit" :disabled="submitting">{{ submitting ? '登録中です' : '登録する' }}</button>
      <p class="auth-note">登録済みの方は <NuxtLink to="/login">ログイン</NuxtLink></p>
    </form>
  </div>
</template>
